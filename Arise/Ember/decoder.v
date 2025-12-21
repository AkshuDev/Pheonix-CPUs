`timescale 1ns/1ps

module decoder #(
    parameter DATA_W = 64,
    parameter INST_W = 32,
    parameter REG_W = 6
) (
    input wire [INST_W-1:0] inst,
    input wire [DATA_W-1:0] imm_in,
    input wire imm_in_en,
    
    // Decoded
    output reg [11:0] opcode,
    output reg [3:0] mode,
    output reg [5:0] rsrc,
    output reg [5:0] rdest,
    output reg [3:0] flags,
    output reg [DATA_W-1:0] imm,

    // Signals
    output reg imm_en,
    output reg decoded_valid,

    // Basic
    input wire clk,
    input wire rst
);  
    reg waiting_for_imm;
    always @(posedge clk) begin
        if (rst) begin
            waiting_for_imm <= 0;
            decoded_valid <= 0;
        end else begin
            decoded_valid <= 0;

            if (waiting_for_imm) begin
                if (imm_in_en) begin
                    imm <= imm_in;
                    imm_en <= 1;
                    waiting_for_imm <= 0;
                    decoded_valid <= 1;
                end
            end else begin
                opcode <= inst[31:20];
                mode <= inst[19:16];
                rsrc <= inst[15:10];
                rdest <= inst[9:4];
                flags <= inst[3:0];

                if (flags[1] == 1) begin
                    waiting_for_imm <= 1;
                end
                if (flags[0] == 1) begin
                    decoded_valid <= 1;
                end
            end
        end
    end
endmodule
