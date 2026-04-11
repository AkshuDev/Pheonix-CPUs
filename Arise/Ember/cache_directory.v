`timescale 1ps/1ps

module cache_directory #(
    parameter DATA_W = 512,
    parameter ADDR_W = 64,
    parameter NUM_LINES = 1024,
    parameter LINE_SIZE = 64,
    parameter CORE_COUNT = 4
) (
    input wire clk,
    input wire rst,

    input wire req_valid,
    input wire req_wr,
    input wire [$clog2(CORE_COUNT)-1:0] req_core,
    input wire [ADDR_W-1:0] req_addr,

    output reg grant,
    output reg invalidate,
    output reg [CORE_COUNT-1:0] inval_mask,
    output reg [ADDR_W-1:0] inval_addr,

    input wire [CORE_COUNT-1:0] inval_ack,

    output reg mem_req,
    output reg mem_wr,
    output reg [ADDR_W-1:0] mem_addr,
    output reg [DATA_W-1:0] mem_wdata,
    input wire [DATA_W-1:0] mem_rdata,
    input wire mem_ready,
    input wire mem_hit
);
    localparam INDEX_BITS = $clog2(NUM_LINES);

    typedef enum logic [2:0] {M, O, E, S, I} state_t;
    typedef enum logic [2:0] {IDLE, DECIDE, EXECUTE, WAIT_INV, WAIT_MEM} fsm_t;

    state_t dir_mem_state[NUM_LINES];
    reg [CORE_COUNT-1:0] dir_mem_sharers[NUM_LINES];
    reg [$clog2(CORE_COUNT)-1:0] dir_mem_owner[NUM_LINES];

    reg [ADDR_W-1:0] req_addr_latch;
    reg req_wr_latch;
    reg [$clog2(CORE_COUNT)-1:0] req_core_latch;

    reg [INDEX_BITS-1:0] index;

    state_t entry_state;
    reg [CORE_COUNT-1:0] entry_sharers;
    reg [$clog2(CORE_COUNT)-1:0] entry_owner;

    fsm_t cstate;
    fsm_t nstate;

    always @(*) begin
        entry_state = dir_mem_state[index];
        entry_sharers = dir_mem_sharers[index];
        entry_owner = dir_mem_owner[index];
    end

    reg do_inval;
    reg do_mem;
    reg do_grant;
    reg [CORE_COUNT-1:0] next_inval_mask;

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < NUM_LINES; i++) begin
                dir_mem_state[i] <= I;
                dir_mem_sharers[i] <= 0;
                dir_mem_owner[i] <= 0;
            end
            index <= 0;
            do_inval <= 0;
            do_mem <= 0;
            do_grant <= 0;
            next_inval_mask <= 0;
            nstate <= IDLE;
            cstate <= IDLE;
        end else begin
            cstate <= nstate;

            case (cstate)
                IDLE: begin
                    grant <= 0;

                    mem_req <= 0;
                    mem_wr <= 0;
                    mem_addr <= 0;
                    mem_wdata <= 0;

                    inval_mask <= 0;
                    if (req_valid) begin
                        req_addr_latch <= req_addr;
                        req_core_latch <= req_core;
                        req_wr_latch <= req_wr;
                        index <= req_addr[INDEX_BITS-1:0];
                    end
                end

                DECIDE: begin
                    if (do_inval) begin
                        invalidate <= 1;
                        inval_mask <= next_inval_mask;
                    end else if (do_mem) begin
                        mem_req <= 1;
                        mem_wr <= 0;
                        mem_addr <= req_addr_latch;
                    end else if (do_grant) begin
                        // Handled by execute
                    end
                end

                EXECUTE: begin
                    grant <= 1;

                    if (req_wr_latch) begin
                        dir_mem_state[index] <= M;
                        dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch);
                    end else begin
                        if (entry_state == S) begin
                            dir_mem_state[index] <= S;
                            dir_mem_sharers[index] <= entry_sharers | ({CORE_COUNT{1'b1}} << req_core_latch);
                        end else if (entry_state == E) begin
                            if (entry_owner == req_core_latch) begin
                                dir_mem_state[index] <= E;
                                dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch);
                            end else begin
                                dir_mem_state[index] <= S;
                                dir_mem_sharers[index] <= entry_sharers | ({CORE_COUNT{1'b1}} << req_core_latch);
                            end
                        end else begin
                            dir_mem_state[index] <= E;
                            dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch);
                        end
                    end

                    
                    dir_mem_owner[index] <= req_core_latch;
                end

                WAIT_INV: begin
                    if ((inval_ack & inval_mask) == inval_mask) begin
                        invalidate <= 0;

                        dir_mem_state[index] <= M;
                        dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch);
                        dir_mem_owner[index] <= req_core_latch;

                        inval_addr <= req_addr_latch;
                        grant <= 1;
                    end
                end

                WAIT_MEM: begin
                    if (mem_ready) begin
                        mem_req <= 0;

                        if (req_wr_latch)
                            if (entry_state == M && entry_owner != req_core_latch) begin
                                dir_mem_state[index] <= S;
                                dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch) | (1 << entry_owner);
                            end else begin
                                if (req_wr_latch)
                                    dir_mem_state[index] <= M;
                                else
                                    dir_mem_state[index] <= E;

                                dir_mem_sharers[index] <= ({CORE_COUNT{1'b1}} << req_core_latch);
                            end
                        else
                            dir_mem_state[index] <= E;

                        if (dir_mem_state[index] == M || dir_mem_state[index] == E)
                            dir_mem_owner[index] <= req_core_latch;

                        grant <= 1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        nstate = cstate;
        case (cstate)
            IDLE:
                if (req_valid) nstate = DECIDE;
            DECIDE:
                if (do_mem) nstate = WAIT_MEM;
                else if (do_inval) nstate = WAIT_INV;
                else if (do_grant) nstate = EXECUTE;
                else nstate = IDLE;
            EXECUTE:
                nstate = IDLE;
            WAIT_INV:
                if ((inval_ack & inval_mask) == inval_mask) nstate = IDLE;
            WAIT_MEM:
                if (mem_ready) nstate = IDLE;
        endcase
    end

    always @(*) begin
        do_inval = 0;
        do_mem = 0;
        do_grant = 0;
        next_inval_mask = 0;

        case (entry_state)
            M: begin
                if (entry_owner == req_core_latch) begin
                    do_grant = 1;
                end else begin
                    if (req_wr_latch) begin
                        do_inval = 1;
                        next_inval_mask = (1 << entry_owner);
                    end else begin
                        do_mem = 1;
                    end
                end
            end

            E: begin
                if (req_wr_latch) begin
                    do_grant = 1; // E -> M
                end else begin
                    if (entry_owner == req_core_latch) begin
                        do_grant = 1; // I guess same core
                    end else begin
                        do_grant = 1; // will become S in execute
                    end
                end
            end

            S: begin
                if (req_wr_latch) begin
                    do_inval = 1;
                    next_inval_mask = entry_sharers & ~({CORE_COUNT{1'b1}} << req_core_latch);
                end else begin
                    do_grant = 1;
                end
            end

            I: begin
                do_mem = 1;
            end

            default: ;
        endcase
    end
endmodule