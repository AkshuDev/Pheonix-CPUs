`timescale 1ns/1ps

module regfile_test;

    // Clock and reset
    reg clk = 0;
    reg rst = 0;

    // Write interface
    reg wr_en;
    reg [4:0]  wr1_addr;
    reg [63:0] wr1_data;

    // Read interface
    reg [4:0]  rd1_addr, rd2_addr;
    wire [63:0] rd1_out, rd2_out;

    // Instantiate register file
    regfile uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .wr1_addr(wr1_addr),
        .wr1_data(wr1_data),
        .rd1_addr(rd1_addr),
        .rd1_out(rd1_out),
        .rd2_addr(rd2_addr),
        .rd2_out(rd2_out)
    );

    // Clock generator
    always #5 clk = ~clk;


    // -----------------------------------------------
    // Register dump task
    // -----------------------------------------------
    task dump_all_regs;
        integer k;
        reg [63:0] temp;
        begin
            $display("\n----------------------------------------");
            $display("REGISTER FILE STATE @ time %0t", $time);
            for (k = 0; k < 19; k = k + 1) begin
                rd1_addr = k[4:0];
                #1;
                temp = rd1_out;
                $display("R%0d = %h", k, temp);
            end
            $display("----------------------------------------\n");
        end
    endtask


    // -----------------------------------------------
    // Helper tasks
    // -----------------------------------------------
    task write_reg;
        input [4:0] addr;
        input [63:0] data;
        begin
            @(posedge clk);
            wr_en    <= 1;
            wr1_addr <= addr;
            wr1_data <= data;
            @(posedge clk);
            wr_en    <= 0;

            // dump after every register change
            dump_all_regs;
        end
    endtask

    task read_regs;
        input [4:0] a;
        input [4:0] b;
        begin
            rd1_addr = a;
            rd2_addr = b;
            #1;
        end
    endtask


    // -----------------------------------------------
    // Main test
    // -----------------------------------------------
    integer i;
    reg [63:0] expected;
    reg [63:0] random_val;
    reg [4:0]  rsel;

    initial begin
        $display("---- CPU BOOTUP RESET TEST ----");

        wr_en = 0;
        wr1_addr = 0;
        wr1_data = 0;
        rd1_addr = 0;
        rd2_addr = 0;

        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // dump register file after reset
        dump_all_regs;

        read_regs(0, 0);
        if (rd1_out !== 0)
            $display("FAIL: NULL register not zero after reset");
        else
            $display("PASS: NULL register zero after reset");


        // -----------------------------------------------
        // Full register write/read test
        // -----------------------------------------------
        $display("---- FULL REGISTER WRITE/READ TEST ----");

        for (i = 1; i < 19; i = i + 1) begin
            random_val = $random;

            write_reg(i[4:0], random_val);

            read_regs(i[4:0], 0);
            expected = random_val;

            if (rd1_out !== expected)
                $display("FAIL: R%0d expected %h got %h", i, expected, rd1_out);
        end


        // -----------------------------------------------
        // NULL immutability test
        // -----------------------------------------------
        $display("---- NULL REGISTER IMMUTABILITY TEST ----");

        write_reg(5'd0, 64'hFFFFFFFFFFFFFFFF);

        read_regs(5'd0, 5'd0);

        if (rd1_out !== 0)
            $display("FAIL: NULL register changed! Got %h", rd1_out);
        else
            $display("PASS: NULL register immutable");


        // -----------------------------------------------
        // Random stress test
        // -----------------------------------------------
        $display("---- RANDOMIZED STRESS TEST ----");

        for (i = 0; i < 100; i = i + 1) begin
            rsel = (($random % 18) + 18) % 18;
            if (rsel == 0) rsel = 1;

            random_val = $random;

            write_reg(rsel, random_val);

            read_regs(rsel, 0);

            if (rd1_out !== random_val)
                $display("FAIL [Random]: R%0d expected %h got %h",
                         rsel, random_val, rd1_out);
        end


        $display("---- ALL TESTS COMPLETE ----");
        $finish;
    end

endmodule