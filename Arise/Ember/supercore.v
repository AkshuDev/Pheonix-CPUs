`timescale 1ns/1ps

module supercore (
    input wire clk,
    input wire rst,

    // Ring Interface
    output reg ring_req,
    output reg [63:0] ring_addr,
    input wire ring_ready,
    input wire [63:0] ring_rdata [65536]
);
    localparam [31:0] L2_SIZE = 32'd524288;
    localparam [31:0] L1_SIZE = 32'd65536;
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
    localparam [3:0] L2_DONE = 4'd3;
    localparam [3:0] L2_DONEGRANT = 4'd4;
    reg [63:0] l2_refill_addr;
    reg [31:0] l2_fill_index; // 512 KB = 524288 bytes
    reg [63:0] l2_baddr;

    // Core wires
    wire [3:0] c_ring_req;
    wire [63:0] c_ring_addr [3:0];
    reg [3:0] c_ring_ready;
    reg [63:0] c_ring_rdata [3:0] [0:L1_SIZE];

    wire [3:0] core_inuse;
    
    // Core enable/reset
    reg [3:0] core_enable;
    wire [3:0] core_reset;

    assign core_reset = {4{rst}};

    genvar i;
    generate
        for (i = 0; i < 4; i=i+1) begin : cores
            core #(.DATA_W(64), .ADDR_W(64)) c (
                .clk(clk),
                .rst(rst),
                .enable(core_enable[i]),
                .core_reset(core_reset[i]),
                .core_inuse(core_inuse[i]),
                .ring_req(c_ring_req[i]),
                .ring_addr(c_ring_addr[i]),
                .ring_ready(c_ring_ready[i]),
                .ring_rdata(c_ring_rdata[i])
            );
        end
    endgenerate

    integer j;
    reg [31:0] k;

    always @(posedge clk) begin
        if (rst) begin
            ring_req <= 1'b1;
            ring_addr <= 0;
            l2_state <= L2_FILL; // Refill first
            l2_wr_en <= 0;
            l2_fill_index <= 0;
            l2_refill_addr <= 0;
            k <= 0;
        end else begin
            case (l2_state)
                L2_IDLE: begin
                    for (j = 0; j < 4; j = j + 1) begin
                        if (c_ring_req[j]  && (c_ring_addr[j] > l2_baddr + L2_SIZE || c_ring_addr[j] < l2_baddr)) begin
                            l2_refill_addr <= c_ring_addr[j];
                            ring_req <= 1'b1;
                            l2_state <= L2_FILL;
                            l2_fill_index <= 0;
                        end else if (c_ring_req[j]) begin
                            l2_addr <= c_ring_addr[j];
                            l2_rd_en <= 1'b1;
                            l2_state <= L2_GRANT;
                        end
                    end
                end
                L2_GRANT: begin
                    if (l2_rd_done) begin
                        c_ring_rdata[j][k] <= l2_data;
                        k <= k + 8;
                        l2_addr <= l2_addr + k;
                        if (k >= L1_SIZE - 8)
                            l2_state <= L2_DONEGRANT;
                    end
                end
                L2_FILL: begin
                    if (ring_ready && ring_req || !ring_req) begin
                        ring_req <= 1'b0;
                        l2_wr_en <= 1'b1;
                        l2_addr <= l2_refill_addr;
                        l2_wr_data <= ring_rdata[l2_fill_index];
                        l2_fill_index <= l2_fill_index + 8;
                        if (l2_fill_index >= L2_SIZE - 8) begin
                            l2_state <= L2_DONE;
                            l2_wr_en <= 0;
                        end
                    end
                end
                L2_DONE: begin
                    l2_state <= L2_IDLE;
                    l2_baddr <= l2_refill_addr;
                end
                L2_DONEGRANT: begin
                    l2_rd_en <= 1'b0;
                    l2_state <= L2_IDLE;
                end
            endcase
        end
    end

    // Round-Robin
    always @(*) begin
        // Default: no ready feedback
        for (j = 0; j < 4; j=j+1) begin
            c_ring_ready[j] = 0;
            c_ring_rdata[j] = {64{1'b0}};
        end
    end

    // Initially, cores are disabled
    initial begin
        core_enable = 4'b0000;
    end

endmodule

