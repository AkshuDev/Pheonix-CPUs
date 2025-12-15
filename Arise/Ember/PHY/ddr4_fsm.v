// DDR4 Block 1 - PHY Training FSM
// Implementes coarse + fine delay sweep, window detection, centering, locking and retrying
// NOTES:
// Designed for hostile simulation
// All PHY interactions are abstracted via read_ok and delay_tap
// This module is intentionally CPU-agnostic

timeunit 1ns;
timeprecision 1ps;

module ddr4_fsm #(
    parameter integer LANES = 16,
    parameter integer DELAY_TAPS = 64,
    parameter integer SAMPLES_PER_TAP = 8,
    parameter integer PASS_THRESHOLD = 7,
    parameter integer VALIDATION_SAMPLES = 16,
    parameter integer MAX_RETRIES = 4,
    parameter integer COARSE_STEPS = 8,
    parameter integer MIN_LANES_REQUIRED = 12,
    parameter integer MIN_GROUP_WIDTH = 6,
    parameter integer SETTLE_CYCLES = 16
)(
    input wire clk,
    input wire rst_n,

    input wire start_training,
    input wire [LANES-1:0] read_ok,
    input wire drift_detected,

    input wire fine_done,
    input wire fine_failed,
    input wire [LANES-1:0] lane_valid,
    input wire [$clog2(DELAY_TAPS)-1:0] best_start [0:LANES-1],
    input wire [$clog2(DELAY_TAPS)-1:0] best_end   [0:LANES-1],
    input wire [$clog2(DELAY_TAPS+1)-1:0] best_width [0:LANES-1],

    output reg [$clog2(DELAY_TAPS)-1:0] delay_tap,
    output reg locked,
    output reg training_done,
    output reg training_failed,
    output reg [$clog2(MAX_RETRIES+1)-1:0] retry_count,
    output reg [$clog2(COARSE_STEPS)-1:0] coarse_sel,
    output reg fine_start,
    output reg [$clog2(DELAY_TAPS)-1:0] final_delay_tap
);

    typedef enum logic [3:0] {
        ST_IDLE = 4'd0,
        ST_COARSE_APPLY = 4'd1,
        ST_COARSE_WAIT = 4'd2,
        ST_COARSE_EVAL = 4'd3,
        ST_FINE_START = 4'd4,
        ST_FINE_WAIT = 4'd5,
        ST_CENTER_SELECT = 4'd6,
        ST_LOCK = 4'd7,
        ST_VALIDATION = 4'd8,
        ST_RETRY = 4'd9,
        ST_SUCCESS = 4'd10,
        ST_FAIL = 4'd11
    } fsm_state_t;

    fsm_state_t state, next_state;

    reg [$clog2(SETTLE_CYCLES+1)-1:0] settle_cnt;
    reg [$clog2(VALIDATION_SAMPLES+1)-1:0] val_count;
    reg [$clog2(VALIDATION_SAMPLES+1)-1:0] val_failures;

    reg [$clog2(DELAY_TAPS)-1:0] group_start, group_end;
    reg [$clog2(DELAY_TAPS+1)-1:0] group_width;

    integer l;
    integer valid_lane_count;

    wire [$clog2(DELAY_TAPS)-1:0] center_tap;
    assign center_tap = group_start + (group_width >> 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
            coarse_sel <= '0;
            fine_start <= 1'b0;
            delay_tap <= '0;
            final_delay_tap <= '0;
            retry_count <= '0;
            locked <= 1'b0;
            training_done <= 1'b0;
            training_failed <= 1'b0;
            settle_cnt <= '0;
            val_count <= '0;
            val_failures <= '0;
        end else begin
            state <= next_state;

            case (state)

                ST_IDLE: begin
                    training_done <= 0;
                    training_failed <= 0;
                    locked <= 0;
                end

                ST_COARSE_APPLY: begin
                    fine_start <= 0;
                    settle_cnt <= 0;
                end

                ST_COARSE_WAIT: begin
                    settle_cnt <= settle_cnt + 1'b1;
                end

                ST_FINE_START: begin
                    fine_start <= 1'b1;
                end

                ST_CENTER_SELECT: begin
                    delay_tap <= center_tap;
                    final_delay_tap <= center_tap;
                end

                ST_LOCK: begin
                    locked <= 1'b1;
                    val_count <= 0;
                    val_failures <= 0;
                end

                ST_VALIDATION: begin
                    val_count <= val_count + 1'b1;
                    for (l=0;l<LANES;l=l+1)
                        if (!read_ok[l])
                            val_failures <= val_failures + 1'b1;
                end

                ST_RETRY: begin
                    retry_count <= retry_count + 1'b1;
                    coarse_sel <= coarse_sel + 1'b1;
                    locked <= 0;
                end

                ST_SUCCESS: begin
                    training_done <= 1'b1;
                end

                ST_FAIL: begin
                    training_failed <= 1'b1;
                end

            endcase
        end
    end

    always @(*) begin
        next_state = state;

        case (state)

            ST_IDLE:
                if (start_training)
                    next_state = ST_COARSE_APPLY;

            ST_COARSE_APPLY:
                next_state = ST_COARSE_WAIT;

            ST_COARSE_WAIT:
                if (settle_cnt == SETTLE_CYCLES)
                    next_state = ST_FINE_START;

            ST_FINE_START:
                next_state = ST_FINE_WAIT;

            ST_FINE_WAIT:
                if (fine_done)
                    next_state = ST_CENTER_SELECT;
                else if (fine_failed)
                    next_state = ST_RETRY;

            ST_CENTER_SELECT:
                next_state = ST_LOCK;

            ST_LOCK:
                next_state = ST_VALIDATION;

            ST_VALIDATION:
                if (val_count == VALIDATION_SAMPLES)
                    next_state = fsm_state_t'((val_failures <= 1) ? ST_SUCCESS : ST_RETRY);

            ST_RETRY:
                if (retry_count >= MAX_RETRIES)
                    next_state = ST_FAIL;
                else
                    next_state = ST_COARSE_APPLY;

            ST_SUCCESS:
                if (drift_detected)
                    next_state = ST_COARSE_APPLY;

            ST_FAIL:
                next_state = ST_FAIL;

        endcase
    end

    always @(*) begin
        group_start = 0;
        group_end = DELAY_TAPS-1;
        valid_lane_count = 0;

        for (l=0;l<LANES;l=l+1) begin
            if (lane_valid[l] && best_width[l] >= MIN_GROUP_WIDTH) begin
                valid_lane_count = valid_lane_count + 1;
                if (best_start[l] > group_start)
                    group_start = best_start[l];
                if (best_end[l] < group_end)
                    group_end = best_end[l];
            end
        end

        if (valid_lane_count < MIN_LANES_REQUIRED)
            group_width = 0;
        else
            group_width = (group_end >= group_start) ? group_end - group_start + 1 : 0;
    end

endmodule
