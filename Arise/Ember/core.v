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
    input wire mem_hit,
    input wire mem_invalidate,
    input wire [ADDR_W-1:0] mem_invalidate_addr
);
    // Cache
    localparam L1_SIZE = 128; // 128KB in reality (128*1024)
    localparam L1I_SIZE = 64; // 64KB in reality (64*1024)
    localparam L1D_SIZE = 64; // 64KB in reality (64*1024)
    localparam L1ID_SIZE = 64; // 64KB in reality (64*1024)

    localparam NUM_LINES = L1_SIZE / LINE_SIZE;
    localparam NUM_LINES_L1I = L1I_SIZE / LINE_SIZE;
    localparam NUM_LINES_L1D = L1D_SIZE / LINE_SIZE;
    localparam NUM_LINES_L1ID = L1ID_SIZE / LINE_SIZE;

    // Memory Protocol (MOESI)
    reg [1:0] l1_rd_en;
    reg [1:0] l1_wr_en;
    reg [ADDR_W-1:0] l1_addr [1:0];
    reg [DATA_W-1:0] l1_wr_data [1:0];
    wire [DATA_W-1:0] l1_rd_data [1:0];
    wire [1:0] l1_hit;
    wire [1:0] l1_ready;

    wire [1:0] l1_using_mem;

    wire [1:0] l1_mem_req;
    wire [1:0] l1_mem_wr;
    wire [ADDR_W-1:0] l1_mem_addr [1:0];
    wire [DATA_W-1:0] l1_mem_wdata [1:0];
    wire [DATA_W-1:0] l1_mem_rdata [1:0];
    wire [1:0] l1_mem_hit;
    wire [1:0] l1_mem_ready;

    genvar i;
    generate
        for (i = 0; i < 2; i = i+1) begin : cachs
            cache_controller #(
                .DATA_W(DATA_W),
                .ADDR_W(ADDR_W),
                .NUM_LINES(NUM_LINES_L1ID),
                .LINE_SIZE(LINE_SIZE),
                .SIZE(L1ID_SIZE)
            ) l1 (
                .clk(clk),
                .rst(rst),
                
                .rd_en(l1_rd_en[i]),
                .wr_en(l1_wr_en[i]),
                .addr(l1_addr[i]),
                .wr_data(l1_wr_data[i]),
                .rd_data(l1_rd_data[i]),
                .hit(l1_hit[i]),
                .ready(l1_ready[i]),

                .using_mem(l1_using_mem[i]),
                .mem_in_use(i == 0 ? l1_using_mem[1] : l1_using_mem[0]),
                
                .mem_req(l1_mem_req[i]),
                .mem_wr(l1_mem_wr[i]),
                .mem_addr(l1_mem_addr[i]),
                .mem_wdata(l1_mem_wdata[i]),
                .mem_rdata(l1_mem_rdata[i]),
                .mem_ready(l1_mem_ready[i]),
                .mem_hit(l1_mem_hit[i]),

                .invalidate(mem_invalidate),
                .invalidate_addr(mem_invalidate_addr)
            );
        end
    endgenerate

    mem_arbiter #(
        .NUM_CORES(2),
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) arbiter (
        .clk(clk),
        .rst(rst),

        .req(l1_mem_req),
        .wr(l1_mem_wr),
        .addr(l1_mem_addr),
        .wdata(l1_mem_wdata),
        .rdata(l1_mem_rdata),
        .hit(l1_mem_hit),
        .ready(l1_mem_ready),
        
        .mem_ready(mem_ready),
        .mem_hit(mem_hit),

        .mem_req(mem_req),
        .mem_wr(mem_wr),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .granted_core()
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
    reg [7:0] alu_op;
    reg [DATA_W-1:0] alu_a, alu_b;
    reg alu_valid;
    wire [DATA_W-1:0] alu_res;
    wire alu_done;

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
    reg alu_en;
    reg [1:0] alu_owner; // 0=none,1=t0,2=t1
    reg last_grant; // 0=t0, 1=t1

    wire grant_t0_alu = t0_req_alu && (!t1_req_alu || last_grant);
    wire grant_t1_alu = t1_req_alu && (!t0_req_alu || !last_grant);

    always @(*) begin
        if (grant_t0_alu) begin
            alu_en = 1;
            alu_valid = t0_alu_valid;
            alu_op = t0_alu_op; alu_a = t0_alu_a; alu_b = t0_alu_b;
            alu_owner = 2'b01;
        end else if (grant_t1_alu) begin
            alu_en = 1;
            alu_valid = t1_alu_valid;
            alu_op = t1_alu_op; alu_a = t1_alu_a; alu_b = t1_alu_b;
            alu_owner = 2'b10;
        end else begin
            alu_en = 0;
            alu_valid = 0;
            alu_op = 0;
            alu_a = 0;
            alu_b = 0;
            alu_owner = 2'b00;
        end
    end

    always @(posedge clk) begin
        if (rst || core_reset) begin
            t0_reset <= 1;
            t1_reset <= 1;
        end else begin
            t0_reset <= 0;
            t1_reset <= 0;
            if (alu_owner != 2'b00 && alu_done) begin
                if (alu_owner == 2'b01) begin
                    t0_alu_res <= alu_res; t0_alu_done <= 1;
                end else if (alu_owner == 2'b10) begin
                    t1_alu_res <= alu_res; t1_alu_done <= 1;
                end
            end
        end
    end

    // Memory stuff
    always @(*) begin
        l1_addr[0] = {DATA_W{1'b0}};
        l1_rd_en[0] = 0;
        l1_wr_en[0] = 0;
        l1_addr[1] = {DATA_W{1'b0}};
        l1_rd_en[1] = 0;
        l1_wr_en[1] = 0;
        l1_wr_data[1] = {DATA_W{1'b0}};

        if (t0_mem_wr) begin
            l1_addr[1] = t0_mem_addr;
            l1_wr_data[1] = t0_mem_wdata;
            l1_wr_en[1] = 1;
        end else if (t1_mem_wr) begin
            l1_addr[1] = t1_mem_addr;
            l1_wr_data[1] = t1_mem_wdata;
            l1_wr_en[1] = 1;
        end

        else if (t0_req_mem) begin
            l1_addr[1] = t0_mem_addr;
            l1_rd_en[1] = 1;
        end else if (t1_req_mem) begin
            l1_addr[1] = t1_mem_addr;
            l1_rd_en[1] = 1;
        end

        else if (t0_req_imem) begin
            l1_addr[0] = t0_imem_addr;
            l1_rd_en[0] = 1;
        end else if (t1_req_imem) begin
            l1_addr[0] = t1_imem_addr;
            l1_rd_en[0] = 1;
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
            t0_imem_ready <= t0_req_imem & l1_ready[0];
            t0_imem_hit <= t0_req_imem & l1_ready[0];
            t0_imem_rdata <= l1_rd_data[0];

            t1_imem_ready <= t1_req_imem & l1_ready[0];
            t1_imem_hit <= t1_req_imem & l1_ready[0];
            t1_imem_rdata <= l1_rd_data[0];

            // Data read
            t0_mem_ready <= t0_req_mem & l1_ready[1];
            t0_mem_hit <= t0_req_mem & l1_ready[1];
            t0_mem_rdata <= l1_rd_data[1];

            t1_mem_ready <= t1_req_mem & l1_ready[1];
            t1_mem_hit <= t1_req_mem & l1_ready[1];
            t1_mem_rdata <= l1_rd_data[1];

            // Data write
            if (t0_mem_wr & l1_ready[1]) begin
                t0_mem_ready <= 1;
                t0_mem_hit <= 0; // writes don't count as hits
            end
            if (t1_mem_wr & l1_ready[1]) begin
                t1_mem_ready <= 1;
                t1_mem_hit <= 0;
            end
        end
    end

    // Defaults
    initial begin
        t0_enable = 1; t1_enable = 0; last_grant = 0;
    end
endmodule