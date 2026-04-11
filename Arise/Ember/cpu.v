`timescale 1ps/1ps

module cpu (
    input wire clk, // from local PLL or something
    input wire rst // Active low and needs clk
);
    localparam L3_SIZE = 4096; // 32MB in reality (33554432 or 1024*1024*32)
    localparam LINE_SIZE = 64;
    localparam LINE_BYTES = LINE_SIZE * 8;
    localparam DATA_W = 512;
    localparam ADDR_W = 64;

    // L3 memory interface
    reg l3_rd_en, l3_wr_en;
    reg [DATA_W-1:0] l3_addr;
    reg [DATA_W-1:0] l3_wr_data;
    wire [DATA_W-1:0] l3_rdata;
    wire l3_ready;

    mem #(.DEPTH(L3_SIZE), .DATA_W(DATA_W)) l3 (
        .clk(clk),
        .rst(rst),
        .rd_en(l3_rd_en),
        .wr_en(l3_wr_en),
        .addr(l3_addr),
        .wr_data(l3_wr_data),
        .rd_data(l3_rdata),
        .rd_done(l3_ready),
        .wr_done() // unused for now
    );

    // Supercores
    wire sc0_req, sc1_req;
    wire [ADDR_W-1:0] sc0_addr, sc1_addr;
    wire [DATA_W-1:0] sc0_wdata, sc1_wdata;
    wire sc0_wr, sc1_wr;
    reg [DATA_W-1:0] sc0_rdata, sc1_rdata;
    reg sc0_ready, sc1_ready;

    supercore sc0 (
        .clk(clk),
        .rst(rst),
        .mem_req(sc0_req),
        .mem_addr(sc0_addr),
        .mem_wdata(sc0_wdata),
        .mem_wr(sc0_wr),
        .mem_rdata(sc0_rdata),
        .mem_ready(sc0_ready)
    );

    supercore sc1 (
        .clk(clk),
        .rst(rst),
        .mem_req(),
        .mem_addr(),
        .mem_wdata(),
        .mem_wr(),
        .mem_rdata(sc1_rdata),
        .mem_ready(sc1_ready)
    );

    // CPU FSM
    localparam ST_IDLE  = 2'd0;
    localparam ST_GRANT = 2'd1;
    localparam ST_FILL  = 2'd2;

    reg [1:0] cpu_state;
    reg grant_which_sc; // 0 = SC0, 1 = SC1
    reg [3:0] lane;
    reg [DATA_W-1:0] current_addr;

    always @(posedge clk) begin
        if (rst) begin
            cpu_state <= ST_IDLE;
            lane <= 0;
            grant_which_sc <= 0;
            l3_rd_en <= 0;
            l3_wr_en <= 0;
            l3_addr <= 0;
        end else begin
            case (cpu_state)
                ST_IDLE: begin
                    l3_rd_en <= 0;
                    sc0_ready <= 0;
                    sc1_ready <= 0;

                    // Check which supercore requests memory
                    if (sc0_req) begin
                        grant_which_sc <= 0;
                        current_addr <= sc0_addr;
                        l3_rd_en <= 1;
                        l3_addr <= sc0_addr;
                        lane <= 0;
                        cpu_state <= ST_GRANT;
                    end else if (sc1_req) begin
                        grant_which_sc <= 1;
                        current_addr <= sc1_addr;
                        l3_rd_en <= 1;
                        l3_addr <= sc1_addr;
                        lane <= 0;
                        cpu_state <= ST_GRANT;
                    end
                end

                ST_GRANT: begin
                    if (l3_ready) begin
                        // Transfer data to correct supercore
                        if (grant_which_sc == 0) begin
                            sc0_rdata <= l3_rdata;
                            sc0_ready <= 1'b1;
                        end else begin
                            sc1_rdata <= l3_rdata;
                            sc1_ready <= 1'b1;
                        end

                        lane <= lane + 1;
                        l3_addr <= l3_addr + LINE_BYTES;

                        // Stop after full line
                        if (lane >= LINE_SIZE-1) begin
                            cpu_state <= ST_IDLE;
                            lane <= 0;
                            l3_rd_en <= 0;
                        end
                    end
                end
            endcase
        end
    end
endmodule