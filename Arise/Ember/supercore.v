`timescale 1ns/1ps

module supercore #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64,
    parameter NUM_CORES = 4,
    parameter LINE_SIZE = 8,
    parameter L2_SIZE = 512*1024
) (
    input wire clk,
    input wire rst,

    // Memory inerface
    output wire mem_req,
    output wire [DATA_W-1:0] mem_addr,
    output wire [DATA_W-1:0] mem_wdata,
    output wire mem_wr,
    input wire [DATA_W-1:0] mem_rdata,
    input wire mem_ready
);
    // Params and stuff
    localparam NUM_LINES = L2_SIZE / LINE_SIZE;

    // Core enables and resets
    reg [NUM_CORES-1:0] core_enable;
    wire [NUM_CORES-1:0] core_reset = {NUM_CORES{rst}};
    wire [NUM_CORES-1:0] core_inuse;

    // L1 cache controller signals
    wire [NUM_CORES-1:0] l1_req;
    wire [NUM_CORES-1:0] l1_wr;
    wire [ADDR_W-1:0] l1_addr [NUM_CORES-1:0];
    wire [DATA_W-1:0] l1_wdata [NUM_CORES-1:0];
    wire [DATA_W-1:0] l1_rdata [NUM_CORES-1:0];
    wire [NUM_CORES-1:0] l1_ready;
    wire [NUM_CORES-1:0] l1_hit;

    // Instantiate cores
    genvar i;
    generate
        for (i = 0; i < NUM_CORES; i = i+1) begin : cores
            core #(
                .DATA_W(DATA_W),
                .ADDR_W(ADDR_W),
                .LINE_SIZE(LINE_SIZE)
            ) c_inst (
                .clk(clk),
                .rst(rst),
                .enable(core_enable[i]),
                .core_reset(core_reset[i]),
                .core_inuse(core_inuse[i]),

                // L1 cache memory interface
                .mem_req(l1_req[i]),
                .mem_addr(l1_addr[i]),
                .mem_wdata(l1_wdata[i]),
                .mem_wr(l1_wr[i]),
                .mem_rdata(l1_rdata[i]),
                .mem_ready(l1_ready[i])
            );
        end
    endgenerate

    // Cache Controller for L2
    wire l2_rd_en, l2_wr_en;
    reg [ADDR_W-1:0] l2_addr;
    reg [DATA_W-1:0] l2_wr_data;
    wire [DATA_W-1:0] l2_rd_data;
    wire l2_hit, l2_ready;

    wire l2_mem_in_use, l2_using_mem;
    assign l2_mem_in_use = 0;

    cache_controller #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .NUM_LINES(NUM_LINES),
        .LINE_SIZE(LINE_SIZE),
        .SIZE(L2_SIZE)
    ) l2 (
        .clk(clk),
        .rst(rst),

        .rd_en(l2_rd_en),
        .wr_en(l2_wr_en),
        .addr(l2_addr),
        .wr_data(l2_wr_data),
        .rd_data(l2_rd_data),
        .hit(l2_hit),
        .ready(l2_ready),

        .mem_in_use(l2_mem_in_use),
        .using_mem(l2_using_mem),

        .mem_req(mem_req),
        .mem_wr(mem_wr),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready),
        .mem_hit(mem_hit)
    );

    reg l2_req, l2_wr;
    reg [$clog2(NUM_CORES)-1:0] granted_core;
    mem_arbiter #(
        .NUM_CORES(NUM_CORES),
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) arbiter (
        .clk(clk),
        .rst(rst),
        
        .req(l1_req),
        .wr(l1_wr),
        .addr(l1_addr),
        .wdata(l1_wdata),
        .rdata(l1_rdata),
        .hit(l1_hit),
        .ready(l1_ready),

        .mem_ready(l2_ready),
        
        .mem_req(l2_req),
        .mem_wr(l2_wr),
        .mem_addr(l2_addr),
        .mem_rdata(l2_rd_data),
        .mem_wdata(l2_wr_data),
        .granted_core(granted_core)
    );

    assign l2_rd_en = l2_req && !l2_wr;
    assign l2_wr_en = l2_req && l2_wr;

    // Initialize: enable only core 0
    initial begin
        core_enable = 4'b0001;
    end
endmodule