`timescale 1ns/1ps

module supercore #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64,
    parameter NUM_CORES = 4,
    parameter LINE_SIZE = 8,
    parameter L2_SIZE = 512 // 512KB in reality (1024*512)
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
    reg [DATA_W-1:0] l1_rdata [NUM_CORES-1:0];
    reg [NUM_CORES-1:0] l1_ready;
    reg [NUM_CORES-1:0] l1_hit;
    reg [NUM_CORES-1:0] l1_invalidate;
    reg [ADDR_W-1:0] l1_invalidate_addr [NUM_CORES-1:0];

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
                .mem_ready(l1_ready[i]),

                .mem_invalidate(l1_invalidate[i]),
                .mem_invalidate_addr(l1_invalidate_addr[i])
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

    reg req_valid;
    reg req_wr;
    reg [ADDR_W-1:0] req_addr;
    reg [$clog2(NUM_CORES)-1:0] req_core;

    wire grant;
    wire invalidate;
    wire [NUM_CORES-1:0] inval_mask;
    reg [NUM_CORES-1:0] inval_ack;
    wire [ADDR_W-1:0] inval_addr;

    cache_directory #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .NUM_LINES(NUM_LINES),
        .LINE_SIZE(LINE_SIZE),
        .CORE_COUNT(NUM_CORES)
    ) cdir (
        .clk(clk),
        .rst(rst),

        .req_valid(req_valid),
        .req_wr(req_wr),
        .req_core(req_core),
        .req_addr(req_addr),
        
        .grant(grant),
        .invalidate(invalidate),
        .inval_mask(inval_mask),
        .inval_ack(inval_ack),
        .inval_addr(inval_addr),
        
        .mem_req(l2_req),
        .mem_wr(l2_wr),
        .mem_addr(l2_addr),
        .mem_wdata(l2_wr_data),
        .mem_rdata(l2_rd_data),
        .mem_ready(l2_ready),
        .mem_hit(l2_hit)
    );

    int j;
    int granting;
    reg found;
    always @(*) begin
        req_valid = 0;
        req_wr = 0;
        req_addr = 0;
        req_core = 0;
        found = 0;
        granting = 0;
        for (j = 0; j < NUM_CORES; j = j + 1) begin
            if (l1_req[j] && !found) begin
                req_core = j;
                req_valid = l1_req[j];
                req_wr = l1_wr[j];
                req_addr = l1_addr[j];
                found = 1;
                granting = j;
            end
        end
    end

    always @(*) begin
        l1_ready = 0;
        l1_hit = 0;
        for (j = 0; j < NUM_CORES; j = j + 1) begin
            l1_rdata[j] = 0;
            l1_invalidate[j] = 0;
        end

        if (found && grant) begin
            l1_ready[granting] = 1;
            l1_hit[granting] = l1_wr[granting] ? 0 : 1;
            if (!l1_wr[granting]) begin
                l1_rdata[granting] = l2_rd_data;
            end

            if (invalidate && (inval_mask[granting])) begin
                l1_invalidate[granting] = 1;
                l1_invalidate_addr[granting] = inval_addr;
                inval_ack[granting] = 1;
            end else begin
                inval_ack[granting] <= 0;
            end
        end
    end

    assign l2_rd_en = l2_req && !l2_wr;
    assign l2_wr_en = l2_req && l2_wr;

    // Initialize: enable only core 0
    initial begin
        core_enable = 4'b0001;
    end
endmodule