`timescale 1ns/1ps

module core #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64,
    parameter LINE_SIZE = 8
)(
    input wire clk,
    input wire rst,

    // Core control
    input wire enable,
    input wire core_reset,
    output wire core_inuse,

    // Memory Interface
    output reg mem_req,
    output reg [ADDR_W-1:0] mem_addr,
    output reg [DATA_W-1:0] mem_wdata,
    output reg mem_wr,
    input wire [DATA_W-1:0] mem_rdata,
    input wire mem_ready,
    input wire mem_hit
);
    // Cache
    localparam L1_SIZE = 128*1024;
    localparam L1I_SIZE = 64*1024;
    localparam L1D_SIZE = 64*1024;

    localparam NUM_LINES = L1_SIZE / LINE_SIZE;
    localparam NUM_LINES_L1I = L1I_SIZE / LINE_SIZE;
    localparam NUM_LINES_L1D = L1D_SIZE / LINE_SIZE;

    // Memory Protocol (MOESI)
    reg l1i_rd_en, l1d_rd_en;
    reg l1i_wr_en, l1d_wr_en;
    reg [ADDR_W-1:0] l1i_addr, l1d_addr;
    reg [DATA_W-1:0] l1i_wr_data, l1d_wr_data;
    wire [DATA_W-1:0] l1i_rd_data, l1d_rd_data;
    wire l1i_hit, l1d_hit;
    wire l1i_ready, l1d_ready;

    wire l1i_using_mem, l1d_using_mem;

    wire l1i_mem_req, l1d_mem_req;
    wire l1i_mem_wr, l1d_mem_wr;
    wire [ADDR_W-1:0] l1i_mem_addr, l1d_mem_addr;
    wire [DATA_W-1:0] l1i_mem_wdata, l1d_mem_wdata;
    wire [DATA_W-1:0] l1i_mem_rdata, l1d_mem_rdata;
    wire l1i_mem_hit, l1d_mem_ready;

    mem_arbiter #(
        .NUM_CORES(2),
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) arbiter (
        .clk(clk),
        .rst(rst),
        
        .req({l1i_mem_req, l1d_mem_req}),
        .wr({l1i_mem_wr, l1d_mem_wr}),
        .addr({l1i_mem_addr, l1d_mem_addr}),
        .wdata({l1i_mem_wdata, l1d_mem_wdata}),
        .rdata({l1i_mem_rdata, l1d_mem_rdata}),
        .hit({l1i_mem_hit, l1d_mem_hit}),
        .ready({l1i_mem_ready, l1d_mem_ready}),
        
        .mem_ready(mem_ready),
        .mem_hit(mem_hit),

        .mem_req(mem_req),
        .mem_wr(mem_wr),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .granted_core()
    );

    cache_controller #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .NUM_LINES(NUM_LINES_L1I),
        .LINE_SIZE(LINE_SIZE),
        .SIZE(L1I_SIZE)
    ) l1i (
        .clk(clk),
        .rst(rst),
        
        .rd_en(l1i_rd_en),
        .wr_en(l1i_wr_en),
        .addr(l1i_addr),
        .wr_data(l1i_wr_data),
        .rd_data(l1i_rd_data),
        .hit(l1i_hit),
        .ready(l1i_ready),

        .using_mem(l1i_using_mem),
        .mem_in_use(l1d_using_mem),
        
        .mem_req(l1i_mem_req),
        .mem_wr(l1i_mem_wr),
        .mem_addr(l1i_mem_addr),
        .mem_wdata(l1i_mem_wdata),
        .mem_rdata(l1i_mem_rdata),
        .mem_ready(l1i_mem_ready),
        .mem_hit(l1i_mem_hit)
    );

    cache_controller #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .NUM_LINES(NUM_LINES_L1D),
        .LINE_SIZE(LINE_SIZE),
        .SIZE(L1D_SIZE)
    ) l1d (
        .clk(clk),
        .rst(rst),
        
        .rd_en(l1d_rd_en),
        .wr_en(l1d_wr_en),
        .addr(l1d_addr),
        .wr_data(l1d_wr_data),
        .rd_data(l1d_rd_data),
        .hit(l1d_hit),
        .ready(l1d_ready),
        
        .using_mem(l1d_using_mem),
        .mem_in_use(l1i_using_mem),

        .mem_req(l1d_mem_req),
        .mem_wr(l1d_mem_wr),
        .mem_addr(l1d_mem_addr),
        .mem_wdata(l1d_mem_wdata),
        .mem_rdata(l1d_mem_rdata),
        .mem_ready(l1d_mem_ready),
        .mem_hit(l1d_mem_hit)
    );

    // Threads
    wire t0_inuse, t1_inuse;
    wire t0_locked, t1_locked;

    reg t0_enable, t1_enable;
    reg t0_reset, t1_reset;

    // ALU signals
    wire t0_req_alu, t1_req_alu;
    wire [7:0] t0_alu_op, t1_alu_op;
    wire [DATA_W-1:0] t0_alu_a, t0_alu_b;
    wire [DATA_W-1:0] t1_alu_a, t1_alu_b;
    reg [DATA_W-1:0] t0_alu_res, t1_alu_res;
    reg t0_alu_done, t1_alu_done;
    wire t0_alu_valid, t1_alu_valid;

    // Thread -> Memory signals
    wire t0_req_mem, t1_req_mem;
    wire [ADDR_W-1:0] t0_mem_addr, t1_mem_addr;
    wire t0_mem_wr, t1_mem_wr;
    wire [DATA_W-1:0] t0_mem_wdata, t1_mem_wdata;
    reg [DATA_W-1:0] t0_mem_rdata, t1_mem_rdata;
    reg t0_mem_ready, t1_mem_ready;
    reg t0_mem_hit, t1_mem_hit;

    wire t0_req_imem, t1_req_imem;
    wire [ADDR_W-1:0] t0_imem_addr, t1_imem_addr;
    reg [DATA_W-1:0] t0_imem_rdata, t1_imem_rdata;
    reg t0_imem_ready, t1_imem_ready;
    reg t0_imem_hit, t1_imem_hit;

    // ALU instantiation
    reg alu_en;
    reg [7:0] alu_op;
    reg [DATA_W-1:0] alu_a, alu_b;
    reg alu_valid;
    wire [DATA_W-1:0] alu_res;
    wire alu_done;
    reg [1:0] alu_owner; // 0=none,1=t0,2=t1
    reg alu_busy;

    alu alu_u (
        .clk(clk),
        .rst(rst),
        .valid(alu_valid),
        .op(alu_op),
        .a(alu_a),
        .b(alu_b),
        .res(alu_res),
        .done(alu_done)
    );

    // Threads
    thread #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .LINE_SIZE(LINE_SIZE)
    ) t0 (
        .clk(clk),
        .rst(rst),
        .thread_reset(t0_reset),
        .enable(t0_enable),
        .in_use(t0_inuse),
        .locked(t0_locked),
        .alu_en(t0_req_alu),
        .alu_op(t0_alu_op),
        .alu_a(t0_alu_a),
        .alu_b(t0_alu_b),
        .alu_res(t0_alu_res),
        .alu_done(t0_alu_done),
        .alu_valid(t0_alu_valid),
        .l1d_addr(t0_mem_addr),
        .l1d_wdata(t0_mem_wdata),
        .l1d_rd_en(t0_req_mem),
        .l1d_wr_en(t0_mem_wr),
        .l1d_rdata(t0_mem_rdata),
        .l1d_ready(t0_mem_ready),
        .l1d_hit(t0_mem_hit),
        .l1i_addr(t0_imem_addr),
        .l1i_rd_en(t0_req_imem),
        .l1i_rdata(t0_imem_rdata),
        .l1i_ready(t0_imem_ready),
        .l1i_hit(t0_imem_hit)
    );

    thread #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W),
        .LINE_SIZE(LINE_SIZE)
    ) t1 (
        .clk(clk),
        .rst(rst),
        .thread_reset(t1_reset),
        .enable(t1_enable),
        .in_use(t1_inuse),
        .locked(t1_locked),
        .alu_en(t1_req_alu),
        .alu_op(t1_alu_op),
        .alu_a(t1_alu_a),
        .alu_b(t1_alu_b),
        .alu_res(t1_alu_res),
        .alu_done(t1_alu_done),
        .alu_valid(t1_alu_valid),
        .l1d_addr(t1_mem_addr),
        .l1d_wdata(t1_mem_wdata),
        .l1d_rd_en(t1_req_mem),
        .l1d_wr_en(t1_mem_wr),
        .l1d_rdata(t1_mem_rdata),
        .l1d_ready(t1_mem_ready),
        .l1d_hit(t1_mem_hit)
    );

    // ALU
    reg last_grant; // 0=t0, 1=t1

    wire grant_t0_alu = t0_req_alu && (!t1_req_alu || last_grant);
    wire grant_t1_alu = t1_req_alu && (!t0_req_alu || !last_grant);

    always @(*) begin
        alu_en = 0; alu_valid = 0; alu_op = 0;
        alu_a = 0; alu_b = 0;

        if (!alu_busy) begin
            if (grant_t0_alu) begin
                alu_en = 1; alu_valid = t0_alu_valid;
                alu_op = t0_alu_op; alu_a = t0_alu_a; alu_b = t0_alu_b;
                alu_owner = 2'b01;
            end else if (grant_t1_alu) begin
                alu_en = 1; alu_valid = t1_alu_valid;
                alu_op = t1_alu_op; alu_a = t1_alu_a; alu_b = t1_alu_b;
                alu_owner = 2'b10;
            end
        end
    end

    always @(posedge clk) begin
        if (rst || core_reset) begin
            t0_reset <= 1; t1_reset <= 1;
            alu_busy <= 0; alu_owner <= 0;
        end else begin
            t0_reset <= 0; t1_reset <= 0;
            if (alu_owner != 2'b00 && alu_done) begin
                if (alu_owner == 2'b01) begin
                    t0_alu_res <= alu_res; t0_alu_done <= 1;
                end else if (alu_owner == 2'b10) begin
                    t1_alu_res <= alu_res; t1_alu_done <= 1;
                end
                alu_busy <= 0; alu_owner <= 2'b00;
            end
        end
    end

    // Memory stuff
    always @(*) begin
        l1i_addr = {DATA_W{1'b0}};
        l1i_rd_en = 0; l1i_wr_en = 0;
        l1d_addr = {DATA_W{1'b0}};
        l1d_rd_en = 0; l1d_wr_en = 0;
        l1d_wr_data = {DATA_W{1'b0}};

        if (t0_mem_wr) begin
            l1d_addr = t0_mem_addr;
            l1d_wr_data = t0_mem_wdata;
            l1d_wr_en = 1;
        end else if (t1_mem_wr) begin
            l1d_addr = t1_mem_addr;
            l1d_wr_data = t1_mem_wdata;
            l1d_wr_en = 1;
        end

        else if (t0_req_mem) begin
            l1d_addr = t0_mem_addr;
            l1d_rd_en = 1;
        end else if (t1_req_mem) begin
            l1d_addr = t1_mem_addr;
            l1d_rd_en = 1;
        end

        else if (t0_req_imem) begin
            l1i_addr = t0_imem_addr;
            l1i_rd_en = 1;
        end else if (t1_req_imem) begin
            l1i_addr = t1_imem_addr;
            l1i_rd_en = 1;
        end
    end

    // Connect back memory responses
    always @(posedge clk) begin
        if (rst) begin
            t0_imem_ready <= 0; t1_imem_ready <= 0;
            t0_imem_hit <= 0; t1_imem_hit <= 0;
            t0_imem_rdata <= {DATA_W{1'b0}}; 
            t1_imem_rdata <= {DATA_W{1'b0}};
            t0_mem_ready <= 0; t1_mem_ready <= 0;
            t0_mem_hit <= 0; t1_mem_hit <= 0;
            t0_mem_rdata <= {DATA_W{1'b0}}; 
            t1_mem_rdata <= {DATA_W{1'b0}};
        end else begin
            // Instruction fetch
            t0_imem_ready <= t0_req_imem & l1i_ready;
            t0_imem_hit <= t0_req_imem & l1i_ready;
            t0_imem_rdata <= l1i_rd_data;

            t1_imem_ready <= t1_req_imem & l1i_ready;
            t1_imem_hit <= t1_req_imem & l1i_ready;
            t1_imem_rdata <= l1i_rd_data;

            // Data read
            t0_mem_ready <= t0_req_mem & l1d_ready;
            t0_mem_hit <= t0_req_mem & l1d_ready;
            t0_mem_rdata <= l1d_rd_data;

            t1_mem_ready <= t1_req_mem & l1d_ready;
            t1_mem_hit <= t1_req_mem & l1d_ready;
            t1_mem_rdata <= l1d_rd_data;

            // Data write
            if (t0_mem_wr & l1d_ready) begin
                t0_mem_ready <= 1;
                t0_mem_hit <= 0; // writes don't count as hits
            end
            if (t1_mem_wr & l1d_ready) begin
                t1_mem_ready <= 1;
                t1_mem_hit <= 0;
            end
        end
    end

    // Defaults
    initial begin
        t0_enable = 1; t1_enable = 0; alu_busy = 0; last_grant = 0;
    end
endmodule