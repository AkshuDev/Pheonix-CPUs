// Register File - NULL, G0-G14, SF, LR, SP (5 bits)

module regfile #(
    parameter DATA_W = 64,
    parameter NUM_REGS = 19,
    parameter REG_ADDR_W = 5 // 5 bits 
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
            regs[16] <= {DATA_W{1'b0}};
            regs[17] <= {DATA_W{1'b0}};
            regs[18] <= {DATA_W{16'hFFFF}};
        end else begin
            // Write is on
            if (wr_en && (wr1_addr != {REG_ADDR_W{1'b0}})) begin // Reg is not NULL
                // Sync Write
                if (wr1_addr < NUM_REGS)
                    regs[wr1_addr] <= wr1_data;
            end
        end
    end
    
    // Async Read (Combo Ports)
    always @(*) begin
        if (rd1_addr < NUM_REGS && (rd1_addr != {REG_ADDR_W{1'b0}}))
            rd1_out = regs[rd1_addr];
        else
            rd1_out = {DATA_W{1'b0}};
    end
endmodule