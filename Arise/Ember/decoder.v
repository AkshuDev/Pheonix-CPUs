`timescale 1ns/1ps

module decoder #(
    parameter DATA_W = 64,
    parameter INST_W = 32,
    parameter REG_W = 6
) (
    input wire [INST_W-1:0] inst,
    input wire [DATA_W-1:0] data,
    
    // Decoded
    output reg [11:0] opcode,
    output reg [3:0] mode,
    output reg [5:0] rsrc,
    output reg [5:0] rdest,
    output reg [3:0] flags,
    output reg [DATA_W-1:0] imm,
    output reg [DATA_W-1:0] disp,
    output reg [DATA_W-1:0] ext,

    // Signals
    output reg imm_present,
    output reg disp_present,
    output reg ext_present,
    output reg finished_decoding,
    output reg decoded_valid,

    // Basic
    input wire clk,
    input wire rst
);  
    reg waiting;
    reg [5:0] waiting_bitmask; // 0=IMM, 1=DISP, 2=EXT, (more will be added)
    always @(posedge clk) begin
        if (rst) begin
            waiting_bitmask <= 0;
            decoded_valid <= 0;
            waiting <= 0;
            finished_decoding <= 0;
        end else begin
            decoded_valid <= 0;
            finished_decoding <= 0;

            if (waiting) begin
                if (waiting_bitmask != 0) begin
                    if (waiting_bitmask[0] == 1'b1) begin
                        waiting_bitmask[0] <= 1'b0;
                        imm <= data;
                    end else if (waiting_bitmask[1] == 1'b1) begin
                        waiting_bitmask[1] <= 1'b0;
                        disp <= data;
                    end else if (waiting_bitmask[2] == 1'b1) begin
                        waiting_bitmask[2] <= 1'b0;
                        ext <= data;
                    end
                end else begin
                    waiting <= 0;
                    finished_decoding <= 1;
                end
            end else begin
                opcode <= inst[31:20];
                mode <= inst[19:16];
                rsrc <= inst[15:10];
                rdest <= inst[9:4];
                flags <= inst[3:0];

                if (flags[1] == 1) begin
                    waiting <= 1;
                    waiting_bitmask[0] <= 1'b1;
                end
                if (flags[2] == 1) begin
                    waiting <= 1;
                    waiting_bitmask[1] <= 1'b1;
                end
                if (flags[3] == 1) begin
                    waiting <= 1;
                    waiting_bitmask[2] <= 1'b1;
                end

                if (flags[1] == 0 && flags[2] == 0 && flags[3] == 0) begin
                    finished_decoding <= 1;
                end

                if (flags[0] == 1) begin
                    decoded_valid <= 1;
                end
            end
        end
    end
endmodule
