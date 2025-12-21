`timescale 1ns/1ps

module mem #(
    parameter DEPTH=1024,
    parameter DATA_W=64
) (
    input wire clk,
    input wire rst,
    input wire rd_en,
    input wire wr_en,
    input wire [DATA_W-1:0] addr,
    input wire [DATA_W-1:0] wr_data,
    output reg wr_done,

    output reg [DATA_W-1:0] rd_data,
    output reg rd_done
);
    localparam BYTES = DATA_W / 8;
    (* ramstyle = "M9K" *) reg [7:0] mem [0:DEPTH-1];
    integer i;

    always @(posedge clk) begin
        rd_done <= 1'b0;
        wr_done <= 1'b0;

        if (rst) begin
            rd_data <= {DATA_W{1'b0}};
            rd_done <= 1'b0;
        end else begin
            if (wr_en) begin
                for (i=0;i<BYTES;i=i+1) begin
                    mem[addr + i] <= wr_data[i*8 +: 8];
                end
                wr_done <= 1'b1;
            end
            if (rd_en) begin
                for (i=0;i<BYTES;i=i+1) begin
                    rd_data[i*8 +: 8] <= mem[addr + i];
                end
                rd_done <= 1'b1;
            end
        end
    end
endmodule
