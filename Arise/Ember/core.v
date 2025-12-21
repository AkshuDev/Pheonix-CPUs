`timescale 1ns/1ps

module core #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64
)(
    input wire clk,
    input wire rst,

    // Core Control
    input wire enable,
    input wire core_reset,
    output wire core_inuse,

    // ring interface
    output reg ring_req,
    output reg [ADDR_W-1:0] ring_addr,
    input wire ring_ready,
    input wire [63:0] ring_rdata [8192:0]
);
    localparam ST_IDLE = 4'd0;
    localparam ST_REQ_L2 = 4'd1;
    localparam ST_FILL = 4'd2;
    localparam ST_DONE = 4'd3;
    localparam ST_GRANT_L1I = 4'd4;
    localparam ST_GRANT_L1D = 4'd5;

    localparam [31:0] L1_SIZE = 32'd65536;

    reg [3:0] core_state;
    reg [ADDR_W-1:0] refill_addr; // base address being refilled
    reg [31:0] fill_index; // counts 0..65516

    // Thread control
    reg t0_enable, t1_enable;
    reg t0_reset, t1_reset;

    wire t0_in_use, t1_in_use;
    wire t0_locked, t1_locked;

    // ALU
    reg  alu_en;
    reg [7:0] alu_op;
    reg [DATA_W-1:0] alu_a, alu_b;
    wire [DATA_W-1:0] alu_res;
    wire alu_done;
    reg alu_valid;
    wire alu_zero, alu_carry, alu_overflow, alu_lt, alu_eq, alu_gt;

    alu alu_u (
        .clk(clk),
        .rst(rst),
        .a(alu_a),
        .b(alu_b),
        .op(alu_op),
        .res(alu_res),
        .done(alu_done),
        .valid(alu_valid),
        .zero(alu_zero),
        .carry(alu_carry),
        .overflow(alu_overflow),
        .lt(alu_lt),
        .eq(alu_eq),
        .gt(alu_gt)
    );

    // L1 Caches
    reg l1i_rd_en, l1d_rd_en;
    reg l1i_wr_en, l1d_wr_en;
    reg [ADDR_W-1:0] l1i_addr, l1d_addr;
    wire [DATA_W-1:0] l1i_data, l1d_data;
    reg [DATA_W-1:0] l1i_wr_data, l1d_wr_data;
    reg [ADDR_W-1:0] l1i_baddr, l1d_baddr; // Base Address
    reg l1i_wr_done, l1d_wr_done;
    reg l1i_rd_done, l1d_rd_done;

    mem #(.DEPTH(L1_SIZE), .DATA_W(DATA_W)) l1i (
        .clk(clk),
        .rst(rst),
        .rd_en(l1i_rd_en),
        .wr_en(l1i_wr_en),
        .addr(l1i_addr),
        .wr_data(l1i_wr_data),
        .rd_data(l1i_data),
        
        .rd_done(l1i_rd_done),
        .wr_done(l1i_wr_done)
    );

    mem #(.DEPTH(L1_SIZE), .DATA_W(DATA_W)) l1d (
        .clk(clk),
        .rst(rst),
        .rd_en(l1d_rd_en),
        .wr_en(l1d_wr_en),
        .addr(l1d_addr),
        .wr_data(l1d_wr_data),
        .rd_data(l1d_data),

        .rd_done(l1d_rd_done),
        .wr_done(l1d_wr_done)
    );

    // Threads
    wire t0_req_alu, t1_req_alu;
    wire [7:0] t0_alu_op, t1_alu_op;
    wire [DATA_W-1:0] t0_alu_a, t0_alu_b;
    wire [DATA_W-1:0] t1_alu_a, t1_alu_b;
    reg [DATA_W-1:0] t0_alu_res, t1_alu_res;
    reg t0_alu_done, t1_alu_done;
    wire t0_alu_valid, t1_alu_valid;

    wire t0_req_l1i, t1_req_l1i;
    wire [ADDR_W-1:0] t0_l1i_addr, t1_l1i_addr;

    wire t0_req_l1d, t1_req_l1d;
    wire [ADDR_W-1:0] t0_l1d_addr, t1_l1d_addr; 

    reg t0_l1i_ready, t1_l1i_ready;
    reg t0_l1d_ready, t1_l1d_ready;
    reg [63:0] t0_l1i_data, t1_l1i_data;
    reg [63:0] t0_l1d_data, t1_l1d_data;

    // Thread connection

    thread t0 (
        .clk(clk),
        .rst(rst),
        .thread_reset(t0_reset),
        .enable(t0_enable),
        .in_use(t0_in_use),
        .locked(t0_locked),

        .alu_en(t0_req_alu),
        .alu_op(t0_alu_op),
        .alu_a(t0_alu_a),
        .alu_b(t0_alu_b),
        .alu_res(t0_alu_res),
        .alu_done(t0_alu_done),
        .alu_valid(t0_alu_valid),

        .read_l1i(t0_req_l1i),
        .l1i_addr(t0_l1i_addr),
        .l1i_data(t0_l1i_data),
        .l1i_ready(t0_l1i_ready),

        .read_l1d(t0_req_l1d),
        .l1d_addr(t0_l1d_addr),
        .l1d_data(t0_l1d_data),
        .l1d_ready(t0_l1d_ready)
    );

    thread t1 (
        .clk(clk),
        .rst(rst),
        .thread_reset(t1_reset),
        .enable(t1_enable),
        .in_use(t1_in_use),
        .locked(t1_locked),

        .alu_en(t1_req_alu),
        .alu_op(t1_alu_op),
        .alu_a(t1_alu_a),
        .alu_b(t1_alu_b),
        .alu_res(t1_alu_res),
        .alu_done(t1_alu_done),
        .alu_valid(t1_alu_valid),

        .read_l1i(t1_req_l1i),
        .l1i_addr(t1_l1i_addr),
        .l1i_data(t1_l1i_data),
        .l1i_ready(t1_l1i_ready),

        .read_l1d(t1_req_l1d),
        .l1d_addr(t1_l1d_addr),
        .l1d_data(t1_l1d_data),
        .l1d_ready(t1_l1d_ready)
    );

    // round-robin
    reg last_grant; // 0 = t0, 1 = t1

    wire grant_t0_alu = t0_req_alu && (!t1_req_alu || last_grant);
    wire grant_t1_alu = t1_req_alu && (!t0_req_alu || !last_grant);

    reg grant_thread; // 0 = T0, 1 = T1

    reg [1:0] alu_owner; // 0 = None, 1 = t0, 2 = t1
    reg alu_busy;

    always @(posedge clk) begin
        if (rst) begin
            core_state <= ST_FILL;
            ring_req <= 1;
            ring_addr <= 0;
            fill_index <= 0;
            l1i_baddr <= 0;
            grant_thread <= 0;
        end else begin
            case (core_state)
                ST_IDLE: begin
                    ring_req <= 0;
                    l1i_wr_en <= 0;
                    fill_index <= 0;
                    if (t0_req_l1i && (t0_l1i_addr < l1i_baddr || t0_l1i_addr >= l1i_baddr+L1_SIZE)) begin
                        refill_addr <= t0_l1i_addr;
                        core_state <= ST_REQ_L2;
                    end else if (t1_req_l1i && (t1_l1i_addr < l1i_baddr || t1_l1i_addr >= l1i_baddr+L1_SIZE)) begin
                        refill_addr <= t1_l1i_addr;
                        core_state <= ST_REQ_L2;
                    end else if (t1_req_l1i) begin
                        grant_thread <= 1;
                        l1i_addr <= t1_l1i_addr;
                        core_state <= ST_GRANT_L1I;
                    end else if (t0_req_l1i) begin
                        grant_thread <= 0;
                        l1i_addr <= t0_l1i_addr;
                        core_state <= ST_GRANT_L1I;
                    end else if (t1_req_l1d) begin
                        grant_thread <= 1;
                        l1d_addr <= t1_l1d_addr;
                        core_state <= ST_GRANT_L1D;
                    end else if (t0_req_l1d) begin
                        grant_thread <= 0;
                        l1d_addr <= t0_l1d_addr;
                        core_state <= ST_GRANT_L1D;
                    end
                end

                ST_GRANT_L1I: begin
                    l1i_rd_en <= 1'b1;
                    if (l1i_rd_done) begin
                        if (grant_thread == 1'b0) begin
                            t0_l1i_data <= l1i_data;
                            t0_l1i_ready <= 1'b1;
                        end else begin
                            t1_l1i_data <= l1i_data;
                            t1_l1i_ready <= 1'b1;
                        end
                        l1i_rd_en <= 1'b0;
                        core_state <= ST_IDLE;
                    end
                end

                ST_GRANT_L1D: begin
                    l1d_rd_en <= 1'b1;
                    if (l1d_rd_done) begin
                        if (grant_thread == 1'b0) begin
                            t0_l1d_data <= l1d_data;
                            t0_l1d_ready <= 1'b1;
                        end else begin
                            t1_l1d_data <= l1d_data;
                            t1_l1d_ready <= 1'b1;
                        end
                        l1d_rd_en <= 1'b0;
                        core_state <= ST_IDLE;
                    end
                end

                ST_REQ_L2: begin
                    ring_req <= 1;
                    ring_addr <= refill_addr;
                    if (ring_ready) begin
                        core_state <= ST_FILL;
                        fill_index <= 0;
                    end
                end

                ST_FILL: begin
                    if (ring_ready && ring_req || !ring_req) begin
                        ring_req <= 0;
                        l1i_wr_en <= 1;
                        l1i_addr <= fill_index;

                        l1i_wr_data <= ring_rdata[fill_index];
                        fill_index <= fill_index + 8;
                        if (fill_index >= L1_SIZE - 8) begin
                            core_state <= ST_DONE;
                            l1i_wr_en <= 0;
                        end
                    end
                end

                ST_DONE: begin
                    l1i_baddr <= refill_addr;
                    core_state <= ST_IDLE;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            last_grant <= 1'b0;
            t1_enable <= 1'b0;
            t0_enable <= 1'b0;
            alu_busy <= 1'b0;
            t1_reset <= 1'b0;
            t0_reset <= 1'b0;
            alu_owner <= 2'b00;
        end else if (core_reset) begin
            last_grant <= 1'b0;
            t1_enable <= 1'b0;
            t0_enable <= 1'b0;
            alu_busy <= 1'b0;
            t1_reset <= 1'b1;
            t0_reset <= 1'b1;
            alu_owner <= 2'b0;
        end else begin
            t1_reset <= 1'b0;
            t0_reset <= 1'b0;
            if (enable) begin
                if (!alu_busy) begin
                    if (grant_t0_alu) begin
                        last_grant <= 1'b0;
                    end else if (grant_t1_alu) begin
                        last_grant <= 1'b1;
                    end
                end 
            end
        end
    end

    // Shared resource muxing
    always @(*) begin
        alu_en = 1'b0;
        alu_op = 8'h00;
        alu_a = {DATA_W{1'b0}};
        alu_b = {DATA_W{1'b0}};

        if (!alu_busy) begin
            if (grant_t0_alu) begin
                alu_en = 1'b1;
                alu_op = t0_alu_op;
                alu_a = t0_alu_a;
                alu_b = t0_alu_b;
                alu_valid = t0_alu_valid;
                alu_busy = 1'b1;
                alu_owner = 2'b01;
            end else if (grant_t1_alu) begin
                alu_en = 1'b1;
                alu_op = t1_alu_op;
                alu_a = t1_alu_a;
                alu_b = t1_alu_b;
                alu_valid = t1_alu_valid;
                alu_busy = 1'b1;
                alu_owner = 2'b10;
            end
        end else begin
            if (alu_owner == 2'b01 && alu_done) begin
                t0_alu_done = alu_done;
                t0_alu_res = alu_res;
                alu_busy = 1'b0;
                alu_owner = 2'b00;
            end else if (alu_owner == 2'b10 && alu_done) begin
                t1_alu_done = alu_done;
                t1_alu_res = alu_res;
                alu_busy = 1'b0;
                alu_owner = 2'b00;
            end
        end
    end
endmodule

