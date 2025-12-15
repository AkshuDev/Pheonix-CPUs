`timescale 1ns/1ps

module tb_ddr4_fsm;

    localparam LANES = 16;
    localparam DELAY_TAPS = 64;
    localparam COARSE_STEPS = 8;

    reg clk;
    reg rst_n;

    initial clk = 0;
    always #5 clk = ~clk;

    reg start_training;
    reg [LANES-1:0] read_ok;
    reg drift_detected;

    reg fine_done;
    reg fine_failed;
    reg [LANES-1:0] lane_valid;
    reg [$clog2(DELAY_TAPS)-1:0] best_start [0:LANES-1];
    reg [$clog2(DELAY_TAPS)-1:0] best_end   [0:LANES-1];
    reg [$clog2(DELAY_TAPS+1)-1:0] best_width [0:LANES-1];

    wire [$clog2(DELAY_TAPS)-1:0] delay_tap;
    wire locked;
    wire training_done;
    wire training_failed;
    wire [$clog2(8)-1:0] retry_count;
    wire [$clog2(COARSE_STEPS)-1:0] coarse_sel;
    wire fine_start;
    wire [$clog2(DELAY_TAPS)-1:0] final_delay_tap;

    integer l;
    integer i;

    // TRUE windows (coarse-dependent)
    integer true_start [0:LANES-1];
    integer true_end   [0:LANES-1];

    ddr4_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_training(start_training),
        .read_ok(read_ok),
        .drift_detected(drift_detected),
        .fine_done(fine_done),
        .fine_failed(fine_failed),
        .lane_valid(lane_valid),
        .best_start(best_start),
        .best_end(best_end),
        .best_width(best_width),
        .delay_tap(delay_tap),
        .locked(locked),
        .training_done(training_done),
        .training_failed(training_failed),
        .retry_count(retry_count),
        .coarse_sel(coarse_sel),
        .fine_start(fine_start),
        .final_delay_tap(final_delay_tap)
    );

    // READ_OK MODEL
    always @(posedge clk) begin
        for (l=0;l<LANES;l=l+1) begin
            if (delay_tap >= true_start[l] && delay_tap <= true_end[l]) begin
                read_ok[l] <= ($urandom_range(0,99) < 95);
                $display("[%0t] LANE [%0d] Read Ok [%0d]", $time, l, read_ok[l]);
            end else begin
                read_ok[l] <= ($urandom_range(0,99) < 5);
                $display("[%0t] LANE [%0d] Read Ok [%0d]", $time, l, read_ok[l]);
            end
        end
    end

    // FINE TRAINING MODEL
    always @(posedge clk) begin
        if (!rst_n) begin
            fine_done <= 0;
            fine_failed <= 0;
        end else if (fine_start) begin
            fine_done <= 0;
            fine_failed <= 0;

            for (l=0;l<LANES;l=l+1) begin
                if (true_end[l] > true_start[l] + 5) begin
                    lane_valid[l] <= 1;
                    best_start[l] <= true_start[l];
                    best_end[l] <= true_end[l];
                    best_width[l] <= true_end[l] - true_start[l] + 1;
                end else begin
                    lane_valid[l] <= 0;
                    best_width[l] <= 0;
                end
            end

            #200;
            fine_done <= 1;
        end else begin
            fine_done <= 0;
            fine_failed <= 0;
        end
    end

    // COARSE WINDOW GENERATOR
    task regenerate_windows;
        integer base;
        begin
            for (l=0;l<LANES;l=l+1) begin
                base = coarse_sel * (DELAY_TAPS/COARSE_STEPS);
                true_start[l] = base + $urandom_range(2,6);
                true_end[l] = true_start[l] + $urandom_range(10,20);
            end
        end
    endtask

    always @(posedge clk) begin
        if (fine_start)
            regenerate_windows();
    end

    initial begin
        $display("==============================================");
        $display("DDR4 FSM HOSTILE SIMULATION");
        $display("==============================================");

        rst_n = 0;
        start_training = 0;
        drift_detected = 0;
        read_ok = 0;

        for (l=0;l<LANES;l=l+1) begin
            lane_valid[l] = 0;
            best_width[l] = 0;
        end

        #50;
        rst_n = 1;

        #50;
        start_training = 1;
        #10;
        start_training = 0;

        wait (training_done || training_failed);

        if (training_done) begin
            $display("[%0t] TRAINING SUCCESS", $time);
            $display("COARSE=%0d FINAL_TAP=%0d", coarse_sel, final_delay_tap);
        end else begin
            $display("[%0t] TRAINING FAILED", $time);
        end

        #20;
        $finish;
    end

endmodule
