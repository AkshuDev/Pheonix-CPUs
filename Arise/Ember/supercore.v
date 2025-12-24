`timescale 1ns/1ps

module supercore (
    input wire clk,
    input wire rst,

    // Ring Interface
    output reg ring_req,
    output reg [63:0] ring_addr,
    input wire ring_ready,
    input wire [63:0] ring_rdata [0:7]
);
    localparam [31:0] L2_SIZE = 32'd524288;
    localparam [31:0] L1_SIZE = 32'd8192;
    localparam LINE_SIZE = 8;
    localparam LINE_BYTES = LINE_SIZE * 8;
    localparam NUM_LINES = L2_SIZE / LINE_BYTES;
    // L2 (Total: 256KB)
    
    reg l2_rd_en;
    reg l2_wr_en;
    reg [63:0] l2_addr;
    reg [63:0] l2_wr_data;

    wire [63:0] l2_data;
    wire l2_rd_done;
    wire l2_wr_done;

    mem #(.DEPTH(L2_SIZE), .DATA_W(64)) l2 ( // 256 KB
        .clk(clk),
        .rst(rst),
        .rd_en(l2_rd_en),
        .wr_en(l2_wr_en),
        .addr(l2_addr),
        .wr_data(l2_wr_data),
        .rd_data(l2_data),

        .rd_done(l2_rd_done),
        .wr_done(l2_wr_done)
    );

    reg [3:0] l2_state;
    localparam [3:0] L2_IDLE = 4'd0;
    localparam [3:0] L2_GRANT = 4'd1;
    localparam [3:0] L2_FILL = 4'd2;

    reg [63:0] l2_refill_addr;
    reg [31:0] l2_fill_index; // 512 KB = 524288 bytes
    reg [63:0] l2_baddr;
    reg [63:0] l2_line_valid [NUM_LINES];

    // Core wires
    wire [3:0] c_ring_req;
    wire [63:0] c_ring_addr [3:0];
    reg [3:0] c_ring_ready;
    reg [63:0] c0_ring_rdata [0:LINE_SIZE-1];
    reg [63:0] c1_ring_rdata [0:LINE_SIZE-1];
    reg [63:0] c2_ring_rdata [0:LINE_SIZE-1];
    reg [63:0] c3_ring_rdata [0:LINE_SIZE-1];

    wire [3:0] core_inuse;
    
    // Core enable/reset
    reg [3:0] core_enable;
    wire [3:0] core_reset;

    assign core_reset = {4{rst}};

    core #(.DATA_W(64), .ADDR_W(64)) c0 (
        .clk(clk),
        .rst(rst),
        .enable(core_enable[0]),
        .core_reset(core_reset[0]),
        .core_inuse(core_inuse[0]),
        .ring_req(c_ring_req[0]),
        .ring_addr(c_ring_addr[0]),
        .ring_ready(c_ring_ready[0]),
        .ring_rdata(c0_ring_rdata)
    );

    core #(.DATA_W(64), .ADDR_W(64)) c1 (
        .clk(clk),
        .rst(rst),
        .enable(core_enable[1]),
        .core_reset(core_reset[1]),
        .core_inuse(core_inuse[1]),
        .ring_req(c_ring_req[1]),
        .ring_addr(c_ring_addr[1]),
        .ring_ready(c_ring_ready[1]),
        .ring_rdata(c1_ring_rdata)
    );


    core #(.DATA_W(64), .ADDR_W(64)) c2 (
        .clk(clk),
        .rst(rst),
        .enable(core_enable[2]),
        .core_reset(core_reset[2]),
        .core_inuse(core_inuse[2]),
        .ring_req(c_ring_req[2]),
        .ring_addr(c_ring_addr[2]),
        .ring_ready(c_ring_ready[2]),
        .ring_rdata(c2_ring_rdata)
    );


    core #(.DATA_W(64), .ADDR_W(64)) c3 (
        .clk(clk),
        .rst(rst),
        .enable(core_enable[3]),
        .core_reset(core_reset[3]),
        .core_inuse(core_inuse[3]),
        .ring_req(c_ring_req[3]),
        .ring_addr(c_ring_addr[3]),
        .ring_ready(c_ring_ready[3]),
        .ring_rdata(c3_ring_rdata)
    );

    integer j;
    reg [2:0] coreidx;
    reg [31:0] k;

    always @(posedge clk) begin
        if (rst) begin
            ring_req <= 0;
            ring_addr <= 0;
            l2_state <= L2_IDLE;
            l2_wr_en <= 0;
            l2_fill_index <= 0;
            l2_refill_addr <= 0;
            k <= 0;
            coreidx <= 0;
        end else begin
            case (l2_state)
                L2_IDLE: begin
                    for (j = 0; j < 4; j = j + 1) begin
                        if (c_ring_req[j]  && !l2_line_valid[c_ring_addr[j] / LINE_BYTES]) begin
                            l2_refill_addr <= c_ring_addr[j];
                            ring_req <= 1'b1;
                            l2_state <= L2_FILL;
                            l2_fill_index <= 0;
                            coreidx <= j;
                        end else if (c_ring_req[j] && l2_line_valid[c_ring_addr[j] / LINE_BYTES]) begin
                            l2_addr <= c_ring_addr[j];
                            l2_rd_en <= 1'b1;
                            l2_state <= L2_GRANT;
                            coreidx <= j;
                        end
                    end
                end
                L2_GRANT: begin
                    if (ring_ready && ring_req) begin
                        l2_state <= L2_FILL;
                        l2_fill_index <= 0;
                    end else if (!ring_req) begin
                        l2_rd_en <= 1'b1;
                        if (k <= LINE_SIZE-1 && l2_rd_done) begin
                            l2_addr <= l2_addr + LINE_BYTES;
                            k <= k + 1;
                            case (coreidx)
                                0:
                                    c0_ring_rdata[k] <= l2_data;
                                1:
                                    c1_ring_rdata[k] <= l2_data;
                                2:
                                    c2_ring_rdata[k] <= l2_data;
                                3:
                                    c3_ring_rdata[k] <= l2_data;
                            endcase
                        end else if (k > LINE_SIZE-1) begin
                            l2_rd_en <= 1'b0;
                            c_ring_ready[coreidx] <= 1'b1;
                            coreidx <= 0;
                            l2_state <= L2_IDLE;
                            k <= 0;
                        end
                    end
                end
                L2_FILL: begin
                    if ((ring_ready && ring_req) || !ring_req) begin
                        l2_wr_en <= 1'b1;
                        l2_addr <= l2_refill_addr + (l2_fill_index * 8);
                        l2_wr_data <= ring_rdata[l2_fill_index];
                        l2_fill_index <= l2_fill_index + 1;

                        if (l2_fill_index >= LINE_SIZE) begin
                            l2_wr_en <= 1'b0;
                            l2_line_valid[l2_refill_addr / LINE_BYTES] <= 1'b1;
                            ring_req <= 1'b0;
                            l2_state <= L2_IDLE;
                        end
                    end
                end
            endcase
        end
    end

    // Round-Robin
    always @(*) begin
        if (rst) begin
            core_enable[0] = 1'b1;
            core_enable[1] = 1'b0;
            core_enable[2] = 1'b0;
            core_enable[3] = 1'b0;
            for (integer l = 0; l < LINE_SIZE/8; l = l + 1)
                l2_line_valid[l] = 1'b0;
        end else begin
            // Default: no ready feedback
            for (j = 0; j < 4; j=j+1) begin
                c_ring_ready[j] = 0;
            end
        end
    end

    // Initially, cores are disabled EXCEPT core 0
    initial begin
        core_enable[0] = 1'b1;
        core_enable[1] = 1'b0;
        core_enable[2] = 1'b0;
        core_enable[3] = 1'b0;
    end

endmodule

