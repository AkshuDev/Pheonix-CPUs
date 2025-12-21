`timescale 1ns/1ps

// Register File - NULL, G0-G30, SF, LR, SP (6 bits)

module regfile #(
    parameter DATA_W = 64,
    parameter NUM_REGS = 34,
    parameter REG_ADDR_W = 6 // 6 bits 
)
(
    input wire clk, // Clock
    input wire rst, // Sync Reset (active high)
    
    // Write
    input wire wr_en,
    
    // Write Port 1
    input wire [REG_ADDR_W-1:0] wr1_addr,
    input wire [DATA_W-1:0] wr1_data,
    
    // Read Port 1
    input wire [REG_ADDR_W-1:0] rd1_addr,
    output reg [DATA_W-1:0] rd1_out,
    
    // Read Port 2
    input wire [REG_ADDR_W-1:0] rd2_addr,
    output reg [DATA_W-1:0] rd2_out
);
    // Storage
    reg [DATA_W-1:0] regs [0:NUM_REGS-1];
    
    // Init special regs on reset
    always @(posedge clk) begin
        if (rst) begin
            // Reset is enabled
            for (integer i = 0; i < NUM_REGS; i = i + 1)
                regs[i] <= {DATA_W{1'b0}};
            regs[33] <= {{(DATA_W-16){1'b0}}, 16'hFFFF}; 
        end else begin
            // Write is on
            if (wr_en && (wr1_addr != {REG_ADDR_W{1'b0}})) begin // Reg is not NULL
                // Sync Write
                if (wr1_addr < NUM_REGS)
                    regs[wr1_addr] <= wr1_data;
            end
        end
    end
    
    assign rd1_out = (rd1_addr < NUM_REGS && (rd1_addr != 0)) ? regs[rd1_addr] : {DATA_W{1'b0}};
    assign rd2_out = (rd2_addr < NUM_REGS && (rd2_addr != 0)) ? regs[rd2_addr] : {DATA_W{1'b0}};
endmodule
