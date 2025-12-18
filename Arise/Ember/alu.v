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
    output reg zero
);
    always @(posedge clk) begin
        carry <= 1'b0;
        overflow <= 1'b0;
        eq <= 1'b0;
        lt <= 1'b0;
        gt <= 1'b0;

        if (valid && !rst) begin
            case (op)
                // Maths
                8'b0000_0001: {carry, res} <= a + b; // ADD
                8'b0000_0010: begin // SUB
                    {carry, res} <= a - b;
                    overflow <= ((a[DATA_W-1] ^ b[DATA_W-1]) & (a[DATA_W-1] ^ res[DATA_W-1]));
                end
                8'b0000_0011: res <= a * b; // MUL
                8'b0000_0100: res <= a / b; // DIV
                // Logical
                8'b0000_0101: res <= a & b; // AND
                8'b0000_0110: res <= a | b; // OR
                8'b0000_0111: res <= a ^ b; // XOR
                8'b0000_1000: begin // UCMP (Unsigned)
                    res <= {DATA_W{1'b0}};
                    if (a == b)
                        eq <= 1'b1;
                    else if (a > b)
                        gt <= 1'b1;
                    else
                        lt <= 1'b1;
                end
                8'b0000_1001: res <= ~a; // NOT
                // Shifts
                8'b0000_1010: res <= a << b[5:0]; //LOGICAL LSHIFT
                8'b0000_1011: res <= a >> b[5:0]; // LOGICAL RSHIFT
                8'b0000_1100: res <= $signed(a) >>> b[5:0]; // ARITHEMETIC RSHIFT
                8'b0000_1101: res <= {a[DATA_W-2:0], a[DATA_W-1]}; // Rotate
                // More
                8'b0000_1110: begin // CMP (Signed)
                    res <= {DATA_W{1'b0}};
                    if (a == b)
                        eq <= 1'b1;
                    else if ($signed(a) > $signed(b))
                        gt <= 1'b1;
                    else
                        lt <= 1'b1;
                end
                8'b0000_1111: res <= ~(a & b); // NAND
                8'b0001_0000: res <= ~(a | b); // NOR
                8'b0001_0001: res <= ~(a ^ b); // XNOR
                default: res <= {DATA_W{1'b0}}; // Result is 0
            endcase
        end else begin
            res <= {DATA_W{1'b0}};
        end
    end

    assign zero = (res == {DATA_W{1'b0}});
endmodule
