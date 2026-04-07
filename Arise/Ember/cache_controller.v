`timescale 1ns/1ps

module cache_controller #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64,
    parameter NUM_LINES = 1024,
    parameter SIZE = 65536,
    parameter LINE_SIZE = 8
) (
    // Basic
    input wire clk,
    input wire rst,

    // Owner
    input wire rd_en,
    input wire wr_en,
    input wire [ADDR_W-1:0] addr,
    input wire [DATA_W-1:0] wr_data,
    output reg [DATA_W-1:0] rd_data,
    output reg hit,
    output reg ready,

    // Cooporation
    input wire mem_in_use, // Memory being used by coorporative controller
    output reg using_mem, // Memory beging used by this controller

    // External
    output reg mem_req,
    output reg mem_wr,
    output reg [ADDR_W-1:0] mem_addr,
    output reg [DATA_W-1:0] mem_wdata,
    input wire [DATA_W-1:0] mem_rdata,
    input wire mem_ready,
    input wire mem_hit
);
    // Params
    localparam OFFSET_BITS = $clog2(LINE_SIZE);
    localparam INDEX_BITS = $clog2(NUM_LINES);
    localparam TAG_BITS = ADDR_W - INDEX_BITS - OFFSET_BITS;

    // Protcol and Connections and Setup
    typedef enum logic [2:0] {M,O,E,S,I} state_t;
    typedef enum logic [2:0] {
        IDLE, // Waiting for a read/write
        LOOKUP, // Check cache tags/state
        WRITEBACK, // Its pretty obvious
        MEM_REQ, // Request external memory
        MEM_WAIT, // Wait for memory response
        UPDATE // Update cache line and states
    } fsm_state_t;

    (* ramstyle = "M9K" *) reg [DATA_W-1:0] data_array [NUM_LINES];
    (* ramstyle = "M9K" *) reg [TAG_BITS-1:0] tag_array [NUM_LINES];
    (* ramstyle = "M9K" *) state_t state [NUM_LINES];

    fsm_state_t state_fsm, next_state_fsm;
    wire [INDEX_BITS-1:0] index;
    wire [TAG_BITS-1:0] tag;

    // Latch
    reg [ADDR_W-1:0] reg_addr;
    reg reg_rd;
    reg reg_wr;
    reg [DATA_W-1:0] reg_wdata;

    // Wires for SPEED!
    wire tag_match;
    wire valid;
    wire hit_comb;
    wire miss;
    wire dirty;
    wire need_writeback;

    assign tag = reg_addr[ADDR_W-1:ADDR_W-TAG_BITS];
    assign index = reg_addr[OFFSET_BITS+INDEX_BITS-1:OFFSET_BITS];

    assign tag_match = (tag_array[index] == tag);
    assign valid = (state[index] != I);

    assign hit_comb = tag_match & valid;

    assign miss = !hit_comb;
    assign dirty = (state[index] == M) || (state[index] == O);

    assign need_writeback = miss && dirty;

    // Reset Protocol
    integer i;
    integer lookup_cycles;
    // FSM Sequential
    always @(posedge clk) begin
        if (rst) begin
            state_fsm <= IDLE;
            rd_data <= 0;
            ready <= 0;
            hit <= 0;
            mem_req <= 0;
            reg_addr <= 0;
            reg_wdata <= 0;
            reg_rd <= 0;
            reg_wr <= 0;
            lookup_cycles <= 0;

            for (i=0;i<NUM_LINES;i=i+1)
                state[i] <= I;
        end else begin
            state_fsm <= next_state_fsm;

            mem_req <= 0;
            mem_wr <= 0;
            using_mem <= 0;

            case(state_fsm)
                IDLE: begin
                    ready <= 0;
                    hit <= 0;
                    mem_req <= 0;
                    using_mem <= 0;
                    lookup_cycles <= 0;
                    
                    if (rd_en || wr_en) begin
                        reg_addr <= addr;
                        reg_wdata <= wr_data;
                        reg_rd <= rd_en;
                        reg_wr <= wr_en;
                    end
                end

                LOOKUP: begin
                    lookup_cycles <= lookup_cycles + 1;
                    hit <= hit_comb;
                end

                WRITEBACK: begin
                    if (!mem_in_use) begin
                        mem_addr <= {tag_array[index], index, {OFFSET_BITS{1'b0}}};
                        mem_wdata <= data_array[index];
                        mem_wr <= 1;
                        mem_req <= 1;
                        using_mem <= 1;
                    end

                    if (mem_ready && !mem_in_use) begin
                        using_mem <= 0;
                        mem_req <= 0;
                    end
                end

                MEM_REQ: begin
                    if (!mem_in_use) begin
                        mem_req <= 1;
                        mem_addr <= reg_addr & ~(LINE_SIZE-1);
                        mem_wr <= 0;
                        using_mem <= 1;
                    end
                end

                MEM_WAIT: begin
                    if (mem_ready) begin
                        rd_data <= mem_rdata;
                        data_array[index] <= mem_rdata;
                        tag_array[index] <= tag;
                        ready <= 1;
                        using_mem <= 0;
                        mem_req <= 0;

                        if (reg_rd) state[index] <= E;
                        else if (reg_wr) state[index] <= M;
                    end else begin
                        using_mem <= 1;
                    end
                end

                UPDATE: begin
                    if (reg_rd) begin
                        rd_data <= data_array[index];
                        ready <= 1;
                    end
                    if (reg_wr) begin
                        data_array[index] <= reg_wdata;
                        state[index] <= M;
                        ready <= 1;
                    end
                end

                default: begin
                    using_mem <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state_fsm = state_fsm;

        case (state_fsm)
            IDLE: 
                if (rd_en || wr_en)
                    next_state_fsm = LOOKUP;

            LOOKUP:
                if (lookup_cycles > 1)
                    if (hit_comb)
                        next_state_fsm = UPDATE;
                    else if (need_writeback)
                        next_state_fsm = WRITEBACK;
                    else
                        next_state_fsm = MEM_REQ;

            WRITEBACK:
                if (mem_ready && !mem_in_use)
                    next_state_fsm = MEM_REQ;

            MEM_REQ:
                if (!mem_in_use & mem_ready)
                    next_state_fsm = UPDATE;
                else if (!mem_in_use)
                    next_state_fsm = MEM_WAIT;

            MEM_WAIT:
                if (mem_ready)
                    next_state_fsm = UPDATE;

            UPDATE:
                next_state_fsm = IDLE;

            default:
                next_state_fsm = IDLE;
        endcase
    end
endmodule