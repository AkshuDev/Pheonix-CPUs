`timescale 1ns/1ps

module regfile_test #(
    parameter DATA_W = 64,
    parameter REG_COUNT = 32
)(
    input logic clk,
    input logic reset
);
    // DUT signals
    reg wr_en;
    reg [$clog2(REG_COUNT)-1:0] wr1_addr;
    reg [DATA_W-1:0] wr1_data;
    reg [$clog2(REG_COUNT)-1:0] rd1_addr;
    reg [DATA_W-1:0] rd1_out;
    reg [$clog2(REG_COUNT)-1:0] rd2_addr;
    reg [DATA_W-1:0] rd2_out;

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

    // Optional stimulus for debugging
    initial begin
        wait (!reset);
        // simple deterministic write
        wr_en = 1;
        wr1_addr = 0;
        wr1_data = 64'hDEADBEEFCAFEBABE;
        #10;
        wr_en = 0;
        #10;

        wr_en = 1;
        wr1_addr = 1;
        wr1_data = 64'h0123456789ABCDEF;
        #10;
        wr_en = 0;

        // random writes
        for (i=0; i<10; i=i+1) begin
            @(posedge clk);
            wr_en = 1;
            temp_buf = $urandom % REG_COUNT;
            wr1_addr = temp_buf[4:0];
            wr1_data = {32'b0, $urandom};
        end
        wr_en = 0;
    end

endmodule
