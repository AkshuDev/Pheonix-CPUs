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
        // MOV G1, #1
        uut.l3.mem[3] = 8'b00010001; // LSB, Opcode [0:7] (0:7)
        uut.l3.mem[2] = 8'b01010010; // Opcode [8:11] + Mode [0:3] (8:15)
        uut.l3.mem[1] = 8'b00001000; // RSrc [0:5] + RDst [0:1] (16:23)
        uut.l3.mem[0] = 8'b00010001; // MSB, RDst [2:5] + Flags [0:3] (24:31)

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