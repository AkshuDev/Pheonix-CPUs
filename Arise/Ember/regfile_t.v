`timescale 1ns/1ps

module regfile_test;
    localparam DATA_W = 64;
    localparam REG_COUNT = 32;
    localparam REG_ADDR_B = 6;

    reg clk;
    reg reset;

    always #5 clk = ~clk;

    // DUT signals
    reg wr_en;
    reg [REG_ADDR_B-1:0] wr1_addr;
    reg [DATA_W-1:0] wr1_data;
    reg [REG_ADDR_B-1:0] rd1_addr;
    wire [DATA_W-1:0] rd1_out;
    reg [REG_ADDR_B-1:0] rd2_addr;
    wire [DATA_W-1:0] rd2_out;

    reg [31:0] temp_buf;

    wire [DATA_W-1:0] regs [0:REG_COUNT-1]; // output of regfile for harness if it uses it (unconnected)

    integer i;

    // Instantiate DUT
    regfile #(
        .DATA_W(DATA_W)
    ) uut (
        .clk(clk),
        .rst(reset),
        .wr_en(wr_en),
        .wr1_addr(wr1_addr),
        .wr1_data(wr1_data),
        .rd1_addr(rd1_addr),
        .rd1_out(rd1_out),
        .rd2_addr(rd2_addr),
        .rd2_out(rd2_out)
    );

    // Reset sequence
    initial begin
        wr_en = 0;
        wr1_addr = 0;
        wr1_data = 0;
    end


    initial begin
        clk = 0;
        reset = 1;
        wr_en = 0;
        wr1_addr = 0;
        wr1_data = 0;
        rd1_addr = 0;
        rd2_addr = 0;

        #20 reset = 0;
        
        @(posedge clk);
        // simple deterministic write
        wr_en = 1;
        wr1_addr = 1;
        wr1_data = 64'hDEADBEEFCAFEBABE;
        #10;
        wr_en = 0;
        #10;
        rd1_addr = 1;
        #10;
        $display("[%0t] WRITE: %h, READ: %h\n", $time, wr1_data, rd1_out);

        wr_en = 1;
        wr1_addr = 2;
        wr1_data = 64'h0123456789ABCDEF;
        #10;
        wr_en = 0;
        #10;
        rd1_addr = 2;
        #10;
        $display("[%0t] WRITE: %h, READ: %h\n", $time, wr1_data, rd1_out);

        // random writes
        for (i=0; i<10; i=i+1) begin
            @(posedge clk);
            wr_en = 1;
            temp_buf = $urandom % REG_COUNT;
            wr1_addr = temp_buf[4:0];
            wr1_data = {32'b0, $urandom};
            $display("[%0t] WRITE: %h\n", $time, wr1_data);
        end
        wr_en = 0;
        $finish;
    end

endmodule
