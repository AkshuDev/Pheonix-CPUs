`timescale 1ns/1ps

module tb_core;

    reg clk;
    reg rst;

    reg [63:0] inst; // 2 instruction

    core uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        inst = {12'h115, 4'h2, 6'h08, 6'h01, 4'h1, 12'h001, 4'h1, 6'h01, 6'h02, 4'h1};
        rst = 1'b1;

        #50;
        rst = 1'b0;

        $display("RESET DEASSERTED");

        @(posedge clk);

        #10;

        uut.l1i.mem[4] = inst[7:0];
        uut.l1i.mem[5] = inst[15:8];
        uut.l1i.mem[6] = inst[23:16];
        uut.l1i.mem[7] = inst[31:24];
        uut.l1i.mem[0] = inst[39:32];
        uut.l1i.mem[1] = inst[47:40];
        uut.l1i.mem[2] = inst[55:48];
        uut.l1i.mem[3] = inst[63:56];

        $display("PROGRAM LOADED: %h\n\tL1I (1st instruction): %h%h%h%h", inst, uut.l1i.mem[0], uut.l1i.mem[1], uut.l1i.mem[2], uut.l1i.mem[3]);

        #10;

        uut.t0_enable = 1'b1;

        $display("THREAD 0 ENABLE SIGNALS ASSERTED: %b", uut.t0_enable); 

        #100;

        $display("CORE RUNNING");
        $display("T0 in_use = %b", uut.t0_in_use);
        $display("T1 in_use = %b", uut.t1_in_use);

        #200;

        $display("T0.G0 = %h", uut.t0.rf.regs[1]);
        $display("T0.G1 = %h", uut.t0.rf.regs[2]);

        #200;

        $display("L1I RD EN = %b ADDR = %h", uut.l1i_rd_en, uut.l1i_addr);
        $display("L1D RD EN = %b ADDR = %h", uut.l1d_rd_en, uut.l1d_addr);

        #200;

        $display("SIMULATION COMPLETE");
        $finish;
    end

    initial begin
        $dumpfile("obj/core_tb.vcd");
        $dumpvars(0, tb_core);
    end

endmodule
