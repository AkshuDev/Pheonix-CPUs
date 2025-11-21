`timescale 1ns/1ps

module mem #(
    parameter DEPTH = 1024,
    parameter DATA_W=64
) (
    input wire clk,
    input wire rst,
    input wire rd_en,
    input wire wr_en,
    input wire [31:0] byte_addr,
    input wire [DATA_W-1:0] wr_data,

    output reg [DATA_W-1:0] rd_data
);
    reg [DATA_W-1:0] mem [0:DEPTH-1];
    integer i;
    wire [31:0] word_addr = byte_addr[31:0]; // div by 8

    always @(posedge clk) begin
        if (rst) begin
            for (i=0;i<DEPTH;i=i+1) mem[i] <= {DATA_W{1'b0}};
            rd_data <= {DATA_W{1'b0}};
        end else begin
            if (wr_en) mem[word_addr] <= wr_data;
            if (rd_en) rd_data <= mem[word_addr];
        end
    end
endmodule
