`timescale 1ns/1ps

module alu #(
    parameter DATA_W = 64,
    parameter OP_W = 8
) (
    // Input
    input wire [DATA_W-1:0] a,
    input wire [DATA_W-1:0] b,
    input wire [OP_W-1:0] op,
    input wire valid,

    // Clock
    input wire clk,
    input wire rst,

    // Outputs
    output reg [DATA_W-1:0] res,
    output reg carry,
    output reg overflow,
    
    // Flags
    output reg eq, // Equals
    output reg lt, // Less Than
    output reg gt, // Greater Than
    output reg zero,

    output reg done
);
    reg valid_d;

    always @(posedge clk) begin
        carry <= 1'b0;
        overflow <= 1'b0;
        eq <= 1'b0;
        lt <= 1'b0;
        gt <= 1'b0;
        done <= 0;

        if (valid && !rst) begin
            valid_d <= valid;
            done <= valid_d;
            case (op)
                // Maths
                8'h00: begin // NOP
                end
                8'h01: begin
                    {carry, res} <= a + b; // ADD
                end
                8'h02: begin // SUB
                    {carry, res} <= a - b;
                    overflow <= ((a[DATA_W-1] ^ b[DATA_W-1]) & (a[DATA_W-1] ^ res[DATA_W-1]));
                end
                8'h03: res <= a * b; // MUL
                8'h04: res <= a / b; // DIV
                8'h05: begin // CMP (Signed)
                    res <= {DATA_W{1'b0}};
                    if (a == b)
                        eq <= 1'b1;
                    else if ($signed(a) > $signed(b))
                        gt <= 1'b1;
                    else
                        lt <= 1'b1;
                end
                8'h06: begin // UCMP (Unsigned)
                    res <= {DATA_W{1'b0}};
                    if (a == b)
                        eq <= 1'b1;
                    else if (a > b)
                        gt <= 1'b1;
                    else
                        lt <= 1'b1;
                end
                8'h07: res <= a & b; // AND
                8'h08: res <= a | b; // OR
                8'h09: res <= ~a; // NOT
                8'h0A: res <= ~(a & b); // NAND
                8'h0B: res <= ~(a | b); // NOR
                8'h0C: res <= a ^ b; // XOR
                8'h0D: begin // RESERVED
                end
                8'h0E: res <= a << b[5:0]; // SHL
                8'h0F: res <= a >> b[5:0]; // SHR
                8'h10: res <= {a, a} << b[5:0]; // ROTL
                8'h11: res <= {a, a} >> b[5:0]; // ROTR
                8'h12: res <= $signed(a) <<< b[5:0]; // ASHL
                8'h13: res <= $signed(a) >>> b[5:0]; // ASHR
                8'h14: res <= a + 1; // INC
                8'h15: res <= a - 1; // DEC
                8'h16: begin // TEST
                    if (a == 0)
                        res <= 1'b1;
                    else
                        res <= 1'b0;
                end
                default: res <= {DATA_W{1'b0}}; // Result is 0
            endcase
        end else begin
            done <= 1;
        end
    end

    assign zero = (res == {DATA_W{1'b0}});
endmodule
