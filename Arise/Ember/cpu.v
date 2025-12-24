`timescale 1ns/1ps;

module cpu (
    input wire clk,
    input wire rst
);
    localparam [31:0] L3_SIZE = 32'd4194304; // 4 MB
    localparam [31:0] L2_SIZE = 32'd65536;
    localparam LINE_SIZE = 8;
    localparam LINE_BYTES = LINE_SIZE * 8;
    localparam NUM_LINES = L2_SIZE / LINE_BYTES;

    localparam [3:0] ST_IDLE = 4'd0;
    localparam [3:0] ST_GRANT = 4'd1;
    localparam [3:0] ST_FILL = 4'd2;
    localparam [3:0] ST_DONE = 4'd3;

    reg [3:0] cpu_state;

    reg l3_rd_en, l3_wr_en;
    reg [63:0] l3_addr;
    reg [63:0] l3_wr_data;
    wire [63:0] l3_rd_data;
    wire l3_wr_done, l3_rd_done;
    reg [63:0] l3_baddr;

    mem #(.DEPTH(L3_SIZE), .DATA_W(64)) l3 (
        .clk(clk),
        .rst(rst),

        .wr_en(l3_wr_en),
        .rd_en(l3_rd_en),
        .addr(l3_addr),

        .wr_data(l3_wr_data),
        .wr_done(l3_wr_done),
        .rd_data(l3_rd_data),
        .rd_done(l3_rd_done)
    );

    wire sc0_ring_req, sc1_ring_req;
    wire [63:0] sc0_ring_addr, sc1_ring_addr;
    reg sc0_ring_ready, sc1_ring_ready;
    reg [63:0] sc0_ring_rdata [0:LINE_SIZE-1];
    reg [63:0] sc1_ring_rdata [0:LINE_SIZE-1];

    supercore sc0 (
        .clk(clk),
        .rst(rst),

        .ring_req(sc0_ring_req),
        .ring_addr(sc0_ring_addr),
        .ring_ready(sc0_ring_ready),
        .ring_rdata(sc0_ring_rdata)
    );

    supercore sc1 (
        .clk(clk),
        .rst(rst),

        .ring_req(sc1_ring_req),
        .ring_addr(sc1_ring_addr),
        .ring_ready(sc1_ring_ready),
        .ring_rdata(sc1_ring_rdata)
    );

    reg grant_which_sc; // 0 = SC0, 1 = SC1
    reg [31:0] lane;

    always @(posedge clk) begin
        if (rst) begin
            l3_rd_en <= 1'b0;
            l3_wr_en <= 1'b0;
            l3_addr <= 64'd0;
            l3_wr_data <= 64'd0;
            l3_baddr <= 64'd0;
            cpu_state <= ST_IDLE;
            grant_which_sc <= 1'b0;
            lane <= 0;
        end else begin
            case (cpu_state)
                ST_IDLE: begin
                    if (sc0_ring_req && (sc0_ring_addr > l3_baddr + L3_SIZE || sc0_ring_addr < l3_baddr)) begin
                    end else if (sc1_ring_req && (sc1_ring_addr > l3_baddr + L3_SIZE || sc1_ring_addr < l3_baddr)) begin
                    end else if (sc0_ring_req) begin
                        cpu_state <= ST_GRANT;
                        l3_rd_en <= 1'b1;
                        l3_addr <= sc0_ring_addr;
                        grant_which_sc <= 1'b0;
                    end else if (sc1_ring_req) begin
                        cpu_state <= ST_GRANT;
                        l3_rd_en <= 1'b1;
                        l3_addr <= sc1_ring_addr;
                        grant_which_sc <= 1'b1;
                    end
                end
                ST_GRANT: begin
                    if (l3_rd_done) begin
                        l3_rd_en <= 1'b0;

                        if (lane >= LINE_SIZE) begin
                            l3_rd_en <= 1'b0;
                            cpu_state <= ST_IDLE;
                            lane <= 0;
                        end else begin
                            l3_addr <= l3_addr + LINE_BYTES;
                            lane <= lane + 1;
                        end

                        if (grant_which_sc == 1'b0) begin
                            sc0_ring_rdata[lane] <= l3_rd_data;
                            sc0_ring_ready <= 1'b1;
                        end else begin
                            sc1_ring_rdata[lane] <= l3_rd_data;
                            sc1_ring_ready <= 1'b1;
                        end
                    end
                end
            endcase
        end
    end
endmodule
