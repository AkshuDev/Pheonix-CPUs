`timescale 1ns/1ps

module core_t;
    reg clk;
    reg rst;

    // Instantiate the DUT
    core dut (
        .clk(clk),
        .reset(rst)
    );

    always #5 clk = ~clk;


    // --------------------------------------------------
    // Test Program Loader
    // --------------------------------------------------
    task load_program;
        integer i;
    begin
        //------------------------------------------------------
        // Example Program:
        //
        // 0x0000: ADD R1, R2   (dummy encoding)
        // 0x0004: LOAD_FIXED R3, [imm]
        // 0x0008: 64-bit immediate 0x0000_0000_0000_1234
        //------------------------------------------------------

        // Fake ADD instruction (opcode < 0x100)
        dut.imem[0] = 8'b00000000;
        dut.imem[1] = 8'b00010001;
        dut.imem[2] = 8'b00000100;
        dut.imem[3] = 8'b00100001;

        $display("PROGRAM LOADED.");
    end
    endtask

    // --------------------------------------------------
    // Simulation Control
    // --------------------------------------------------
    initial begin
        $display("=== CORE TESTBENCH START ===");

        
        // Hold reset for some cycles
        rst = 1;
        clk = 0;
        #20 rst = 0;

        @(posedge clk);
        $display("[%0t] Reset Deasserted", $time);

        // Run for sufficient cycles
        // Load program into dut.imem
        load_program();

        $display("=== CORE TESTBENCH END ===");
        $finish;
    end

endmodule
