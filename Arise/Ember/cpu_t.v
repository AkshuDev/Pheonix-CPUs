`timescale 1ns/1ps

module tb_cpu;
    reg clk;
    reg rst;

    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Program load and reset
    initial begin
        rst = 1'b1;
        #20;
        rst = 1'b0;

        // Load a test instruction into L3 memory
        // MOV G1, #1 ; MOV G2, #2
        uut.l3.mem[0] = 8'h15; // least significant byte first
        uut.l3.mem[1] = 8'h01;
        uut.l3.mem[2] = 8'h02;
        uut.l3.mem[3] = 8'h00;
        uut.l3.mem[4] = 8'h15;
        uut.l3.mem[5] = 8'h03;
        uut.l3.mem[6] = 8'h04;
        uut.l3.mem[7] = 8'h00;

        $display("RESET DEASSERTED, PROGRAM LOADED");

        #5000; // Run for sufficient cycles

        $display("SIMULATION COMPLETE");
        $finish;
    end

    // VCD waveform dump
    initial begin
        $dumpfile("obj/cpu_t.vcd");
        $dumpvars(0, tb_cpu);
    end
endmodule