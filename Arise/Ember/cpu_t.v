`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg rst;

    reg [63:0] inst; // 2 instruction

    cpu uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        inst = {12'h115, 4'h2, 6'h08, 6'h01, 4'h1, 12'h001, 4'h1, 6'h01, 6'h02, 4'h1};
        uut.l3.mem[4] = inst[7:0];
        uut.l3.mem[5] = inst[15:8];
        uut.l3.mem[6] = inst[23:16];
        uut.l3.mem[7] = inst[31:24];
        uut.l3.mem[0] = inst[39:32];
        uut.l3.mem[1] = inst[47:40];
        uut.l3.mem[2] = inst[55:48];
        uut.l3.mem[3] = inst[63:56];
        rst = 1'b1;

        #50;
        rst = 1'b0;

        $display("RESET DEASSERTED");

        @(posedge clk);

        #10;

        $display("PROGRAM LOADED: %h\n", inst);

        #10;

        uut.sc0.c.enable = 1'b1;
        uut.sc0.c.t0_enable = 1'b1;

        $display("THREAD 0 ENABLE SIGNALS ASSERTED: %b", uut.t0_enable); 

        #200;

        $display("T0.G0 = %h", uut.sc0.c.t0.rf.regs[1]);
        $display("T0.G1 = %h", uut.sc0.c.t0.rf.regs[2]);

        #200;

        $display("SIMULATION COMPLETE");
        $finish;
    end

    initial begin
        $dumpfile("obj/cpu_t.vcd");
        $dumpvars(0, tb_core);
    end

endmodule
