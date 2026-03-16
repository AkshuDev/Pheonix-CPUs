`timescale 1ns/1ps

module thread #(
    DATA_W = 64,
    ADDR_W = 64,
    INST_W = 32,
    LINE_SIZE = 8
) (
    input wire clk,
    input wire rst,

    // Thread Control
    input wire thread_reset,
    input wire enable,
    output reg locked,
    output reg in_use,

    // ALU
    output reg alu_en,
    output reg alu_valid,
    output reg [7:0] alu_op,
    output reg [DATA_W-1:0] alu_a,
    output reg [DATA_W-1:0] alu_b,
    input wire [DATA_W-1:0] alu_res,
    input wire alu_done,

    // L1-D
    output reg [ADDR_W-1:0] l1d_addr,
    output reg [DATA_W-1:0] l1d_wdata,
    input wire [DATA_W-1:0] l1d_rdata,
    output reg l1d_rd_en,
    output reg l1d_wr_en,
    input wire l1d_ready,
    input wire l1d_hit,
    output reg l1d_flush,

    // L1-I
    output reg [ADDR_W-1:0] l1i_addr,
    input wire [DATA_W-1:0] l1i_rdata,
    output reg l1i_rd_en,
    input wire l1i_ready,
    input wire l1i_hit,
    output reg l1i_flush
);

    // Thread FSM
    localparam ST_IDLE = 4'd0;
    localparam ST_FETCH = 4'd1;
    localparam ST_WAIT_L1I = 4'd2;
    localparam ST_DECODE = 4'd3;
    localparam ST_VERIFY = 4'd4;
    localparam ST_EXECUTE = 4'd5;
    localparam ST_EXECUTE_P2 = 4'd6;
    localparam ST_EXECUTE_P3 = 4'd7;
    localparam ST_LOCKED = 4'd8;

    reg [3:0] state, next_state;

    // Inernal State
    wire [DATA_W-1:0] pc;
    reg write_pc;
    reg [DATA_W-1:0] pc_wr_data;

    reg istate_wr_en;
    reg [DATA_W-1:0] istate_wr1_data;
    reg [5:0] istate_wr1_addr;

    wire [DATA_W-1:0] istate_rd1_data;
    reg [5:0] istate_rd1_addr;
    wire [DATA_W-1:0] istate_rd2_data;
    reg [5:0] istate_rd2_addr;

    reg istate_wr_pl_en;
    reg [3:0] istate_wr_pl_data;
    wire [3:0] istate_rd_pl_data;

    internal_state #(.DATA_W(DATA_W)) istate (
        .clk(clk),
        .rst(rst),

        .wr_en(istate_wr_en),
        .wr1_data(istate_wr1_data),
        .wr1_addr(istate_wr1_addr),
        
        .rd1_addr(istate_rd1_addr),
        .rd1_out(istate_rd1_data),
        .rd2_addr(istate_rd2_addr),
        .rd2_out(istate_rd2_data),

        .wr_pl_en(istate_wr_pl_en),
        .wr_pl_data(istate_wr_pl_data),
        .rd_pl_out(istate_rd_pl_data),

        .pc_data(pc_wr_data),
        .wr_pc(write_pc),
        .pc_out(pc)
    );

    // Instruction Buffer
    reg [INST_W-1:0] inst;
    reg inst_valid;

    wire fetch_request = (!l1i_hit || !l1i_ready);

    // Register File
    reg rf_wr_en;
    reg [5:0] rf_wr_addr;
    reg [DATA_W-1:0] rf_wr_data;
    reg [5:0] rf_rd1_addr;
    reg [5:0] rf_rd2_addr;
    wire [DATA_W-1:0] rf_rd1_data;
    wire [DATA_W-1:0] rf_rd2_data;

    regfile #(.DATA_W(DATA_W)) rf (
        .clk(clk),
        .rst(rst),
        .wr_en(rf_wr_en),
        .wr1_addr(rf_wr_addr),
        .wr1_data(rf_wr_data),
        .rd1_addr(rf_rd1_addr),
        .rd1_out(rf_rd1_data),
        .rd2_addr(rf_rd2_addr),
        .rd2_out(rf_rd2_data)
    );

    // Decoder signals
    wire [11:0] opcode;
    wire [3:0] mode;
    wire [5:0] rsrc;
    wire [5:0] rdest;
    wire [3:0] flags;
    wire [DATA_W-1:0] imm64, disp64;
    wire finished_decoding, decoded_valid;

    decoder dec (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .data({DATA_W{1'b0}}),
        .opcode(opcode),
        .mode(mode),
        .rsrc(rsrc),
        .rdest(rdest),
        .flags(flags),
        .imm(imm64),
        .disp(disp64),
        .finished_decoding(finished_decoding),
        .decoded_valid(decoded_valid)
    );

    wire verify_ok = (flags[0] != 1'b0) && (rsrc < 40) && (rdest < 40);

    reg invalid_inst;
    reg using_alu;

    // FSM Sequential
    always @(posedge clk) begin
        if (rst || thread_reset) begin
            state <= ST_IDLE;
            locked <= 1'b0;
            in_use <= 1'b0;
            inst <= 0;
            inst_valid <= 1'b0;
            invalid_inst <= 0;
            alu_en <= 0;
            alu_valid <= 0;
            using_alu <= 0;
            rf_wr_en <= 0;
            write_pc <= 1'b1;
            pc_wr_data <= 0;
        end else begin
            state <= next_state;

            // defaults
            rf_wr_en <= 0;
            alu_en <= 0;
            alu_valid <= 0;
            write_pc <= 0;

            case (state)
                ST_IDLE: begin
                    if (enable) begin
                        in_use <= 1'b1;
                    end
                end

                ST_FETCH: begin
                    // Request instruction from L1-I
                    if (!l1i_hit || !l1i_ready) begin
                        l1i_rd_en <= 1'b1;
                        l1i_addr <= pc;
                    end else begin
                        l1i_rd_en <= 0;
                        inst <= l1i_rdata[INST_W-1:0];
                        inst_valid <= 1'b1;
                        write_pc <= 1;
                        pc_wr_data <= pc + 4;
                    end
                end

                ST_WAIT_L1I: begin
                    if (l1i_ready && l1i_hit) begin
                        l1i_rd_en <= 0;
                        inst <= l1i_rdata[INST_W-1:0];
                        inst_valid <= 1'b1;
                        pc_wr_data <= pc + 4;
                        write_pc <= 1;
                    end
                end

                ST_DECODE: begin
                    // Wait for decoder valid
                    if (decoded_valid && inst_valid) begin
                        inst_valid <= 0;
                    end
                end

                ST_VERIFY: begin
                    if (!verify_ok) begin
                        locked <= 1'b1;
                        invalid_inst <= 1'b1;
                        $display("Thread: Invalid instruction: %h", inst);
                    end else begin
                        locked <= 1'b0;
                        invalid_inst <= 0;
                    end
                end

                ST_EXECUTE: begin
                    $display("Executing:\n\tOpcode: 0x%h\n\tMode: %h\n\tSrc R: %d Dest R: %d\n\tFlags: %h", opcode, mode, rsrc, rdest, flags);
                    if (opcode < 12'h100) begin
                        alu_op <= opcode[7:0];
                        using_alu <= 1'b1;
                        if (mode == 4'h1) begin
                            alu_a <= rf_rd1_data;
                            alu_b <= rf_rd2_data;
                        end else if (mode == 4'h2) begin
                            alu_a <= rf_rd1_data;
                            alu_b <= {58'd0, rsrc};
                        end else begin
                            invalid_inst <= 1'b1;
                        end
                        alu_en <= 1'b1;
                        alu_valid <= 1'b1;
                    end else if (opcode == 12'h115) begin
                        // MOV
                        rf_wr_en <= 1'b1;
                        rf_wr_addr <= rdest;
                        if (mode == 4'h1) rf_wr_data <= rf_rd1_data;
                        else if (mode == 4'h2) rf_wr_data <= {58'd0, rsrc};
                        else if (mode == 4'h3) rf_wr_data <= imm64;
                        else if (mode == 4'h4) rf_wr_data <= disp64 + pc;
                        else invalid_inst <= 1'b1;
                    end else begin
                        invalid_inst <= 1'b1;
                    end
                end

                ST_EXECUTE_P2: begin
                    if (using_alu && alu_done) begin
                        rf_wr_en <= 1'b1;
                        rf_wr_addr <= rdest;
                        rf_wr_data <= alu_res;
                        using_alu <= 0;
                    end
                end

                ST_LOCKED: begin
                    if (verify_ok)
                        locked <= 0;
                    else
                        locked <= 1;
                end
            endcase
        end
    end

    // FSM Combinational
    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: if (enable) next_state = ST_FETCH;

            ST_FETCH: begin
                if (fetch_request)
                    next_state = ST_WAIT_L1I;
                else
                    next_state = ST_DECODE;
            end

            ST_WAIT_L1I:
                if (!fetch_request)
                    next_state = ST_DECODE;

            ST_DECODE:
                if (decoded_valid)
                    next_state = ST_VERIFY;

            ST_VERIFY:
                if (verify_ok)
                    next_state = ST_EXECUTE;
                else
                    next_state = ST_LOCKED;

            ST_EXECUTE:
                next_state = ST_EXECUTE_P2;

            ST_EXECUTE_P2:
                if (!using_alu || alu_done)
                    next_state = ST_FETCH;

            ST_LOCKED:
                if (verify_ok)
                    next_state = ST_VERIFY;
        endcase
    end

endmodule