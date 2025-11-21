`timescale 1ns/1ps

module core_t(
    input wire clk,
    input wire reset
); 
    // Instantiate the DUT
    core dut (
        .clk(clk),
        .reset(reset)
    );


    // --------------------------------------------------
    // Test Program Loader
    // --------------------------------------------------
    task load_program;
        integer i;
    begin
        // Clear IMEM
        for (i = 0; i < 1024; i = i + 1)
            dut.imem[i] = 8'h00;

        //------------------------------------------------------
        // Example Program:
        //
        // 0x0000: ADD R1, R2   (dummy encoding)
        // 0x0004: LOAD_FIXED R3, [imm]
        // 0x0008: 64-bit immediate 0x0000_0000_0000_1234
        //------------------------------------------------------

        // Fake ADD instruction (opcode < 0x100)
        dut.imem[0] = 8'h01;    // (your decoder will interpret this)
        dut.imem[1] = 8'h12;
        dut.imem[2] = 8'h00;
        dut.imem[3] = 8'h00;

        // LOAD_FIXED with immediate (opcode 0x100)
        dut.imem[4] = 8'h00;
        dut.imem[5] = 8'h01;    // opcode low byte
        dut.imem[6] = 8'h00;
        dut.imem[7] = 8'h08;    // immediate-present bit (your format)

        // Immediate: 0x0000_1234
        dut.imem[8]  = 8'h34;
        dut.imem[9]  = 8'h12;
        dut.imem[10] = 8'h00;
        dut.imem[11] = 8'h00;
        dut.imem[12] = 8'h00;
        dut.imem[13] = 8'h00;
        dut.imem[14] = 8'h00;
        dut.imem[15] = 8'h00;

        $display("PROGRAM LOADED.");
    end
    endtask

    // --------------------------------------------------
    // Simulation Control
    // --------------------------------------------------
    initial begin
        $display("=== CORE TESTBENCH START ===");

        // Load program into dut.imem
        load_program();

        // Hold reset for some cycles
        #20;
        $display("[%0t] Reset Deasserted", $time);

        // Run for sufficient cycles
        #600;

        $display("=== CORE TESTBENCH END ===");
        $finish;
    end

endmodule
