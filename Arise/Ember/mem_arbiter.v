`timescale 1ps/1ps

module mem_arbiter #(
    parameter NUM_CORES = 8,
    parameter ADDR_W = 64,
    parameter DATA_W = 512
)(
    input wire clk,
    input wire rst,
    
    input wire [NUM_CORES-1:0] req, // core requests
    input wire [NUM_CORES-1:0] wr, // core write flags
    input wire [ADDR_W-1:0] addr [NUM_CORES-1:0], // addresses
    input wire [DATA_W-1:0] wdata [NUM_CORES-1:0], // concatenated write data
    output reg [DATA_W-1:0] rdata [NUM_CORES-1:0],
    output reg [NUM_CORES-1:0] hit,
    output reg [NUM_CORES-1:0] ready,
    
    input wire mem_ready, // memory ready for current request
    input wire mem_hit,
    
    output reg mem_req, // single memory request
    output reg mem_wr, // single write flag
    output reg [ADDR_W-1:0] mem_addr, // single memory address
    input wire [DATA_W-1:0] mem_rdata,
    output reg [DATA_W-1:0] mem_wdata, // single memory data
    output reg [$clog2(NUM_CORES)-1:0] granted_core // index of the core granted
);
    reg [2:0] last_grant;
    reg granted;

    reg active;
    reg found_core;
    integer i, idx;

    always @(posedge clk) begin
        if (rst) begin
            mem_req <= 0;
            mem_wr <= 0;
            mem_addr <= 0;
            mem_wdata <= 0;
            granted_core <= 0;
            last_grant <= 0;
            active <= 0;
            for (i=0;i<NUM_CORES;i=i+1) begin
                ready[i] <= 0;
                hit[i] <= 0;
            end
        end else begin
            if (!active) begin
                found_core = 0;
                for (i = 1; i <= NUM_CORES; i=i+1) begin
                    idx = (last_grant + i) % NUM_CORES;
                    if (req[idx] && !found_core) begin
                        granted_core <= idx;
                        mem_req <= 1;
                        mem_wr <= wr[idx];
                        mem_addr <= addr[idx];
                        mem_wdata <= wdata[idx];
                        active <= 1;
                        last_grant <= idx;
                        found_core = 1;
                    end
                end
            end else begin
                if (mem_ready) begin
                    rdata[granted_core] <= mem_rdata;
                    ready[granted_core] <= 1;
                    hit[granted_core] <= mem_hit;
                    mem_req <= 0;
                    active <= 0;
                end
            end
        end
    end
endmodule