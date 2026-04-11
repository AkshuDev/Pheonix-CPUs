`timescale 1ps/1ps

module tb_cpu;
    reg clk;
    reg rst;

    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    reg [7:0] program_bytes [0:4096];

    initial begin
        integer fd;
        fd = $fopen("tests/program.pvcpu64.hex", "rb");
        $fread(program_bytes, fd);
        $fclose(fd);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #125 clk = ~clk;
    end

    initial begin
        integer i;
        for (i = 0; i < 128; i = i + 4) begin
            uut.l3.mem[i] = program_bytes[i];
            uut.l3.mem[i + 1] = program_bytes[i + 1];
            uut.l3.mem[i + 2] = program_bytes[i + 2];
            uut.l3.mem[i + 3] = program_bytes[i + 3];
        end
        $display("RESET DEASSERTED, PROGRAM LOADED");
    end

    // Program load and reset
    initial begin
        rst = 1'b1;
        #126;
        rst = 1'b0;

        #125000; // Run for sufficient cycles

        $display("SIMULATION COMPLETE");
        $finish;
    end

    // VCD waveform dump
    initial begin
        $dumpfile("obj/cpu_t.vcd");
        $dumpvars(0, tb_cpu);
    end
endmodule