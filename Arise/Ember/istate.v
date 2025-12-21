`timescale 1ns/1ps

module internal_state #(
    DATA_W = 64
) (
    input wire clk,
    input wire rst,

    input wire wr_en,
    input wire [DATA_W-1:0] wr1_data,
    input wire [5:0] wr1_addr,
    
    input wire [5:0] rd1_addr,
    output reg [DATA_W-1:0] rd1_out,
    input wire [5:0] rd2_addr,
    output reg [DATA_W-1:0] rd2_out,

    input wire wr_pl_en,
    input wire [3:0] wr_pl_data,
    output reg [3:0] rd_pl_out
);
    reg [DATA_W-1:0] regs [0:3];
    reg [3:0] pl;

    always @(posedge clk) begin
        if (rst) begin
            pl <= 4'b0;
            for (integer i = 0; i < 4; i = i + 1)
                regs[i] <= {DATA_W{1'b0}};
        end else if (wr_pl_en == 1'b1) begin
            pl <= wr_pl_data;
        end else if (wr_en && wr1_addr != {DATA_W{1'b0}} && wr1_addr <= 64'd5) begin
            regs[wr1_addr] <= wr1_data;
        end
    end

    assign rd_pl_out = pl;
    assign rd1_out = (rd1_addr != {DATA_W{1'b0}} && rd1_addr < 64'd5) ? regs[rd1_addr] : {DATA_W{1'b0}};
    assign rd2_out = (rd2_addr != {DATA_W{1'b0}} && rd2_addr < 64'd5) ? regs[rd2_addr] : {DATA_W{1'b0}};
endmodule
