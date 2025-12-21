`timescale 1ns/1ps

module thread #(
    DATA_W = 64,
    INST_W = 32
) (
    input wire clk,
    input wire rst,

    // Thread Control
    input wire thread_reset, // Soft-Reset
    input wire enable,
    output reg locked, // Thread is locked due to some exception or error
    output reg in_use, // Thread is in use
    
    // Shared
    // ALU
    output reg alu_en,
    output reg alu_valid,
    output reg [7:0] alu_op,
    output reg [DATA_W-1:0] alu_a,
    output reg [DATA_W-1:0] alu_b,
    input wire [DATA_W-1:0] alu_res,
    input wire alu_zero,
    input wire alu_carry,
    input wire alu_overflow,
    input wire alu_lt,
    input wire alu_eq,
    input wire alu_gt,
    input wire alu_done,
    
    // L1-D
    output reg read_l1d,
    output reg [DATA_W-1:0] l1d_addr,
    input wire [DATA_W-1:0] l1d_data,
    input wire l1d_ready,

    // L1-I
    output reg read_l1i,
    output reg [DATA_W-1:0] l1i_addr,
    input wire [DATA_W-1:0] l1i_data,
    input wire l1i_ready
);
    localparam ST_IDLE = 3'd0;
    localparam ST_FETCH = 3'd1;
    localparam ST_DECODE = 3'd2;
    localparam ST_VERIFY = 3'd3;
    localparam ST_EXECUTE = 3'd4;
    localparam ST_EXECUTE_P2 = 3'd5;
    localparam ST_EXECUTE_P3 = 3'd6;
    localparam ST_LOCKED = 3'd7;
    
    reg [2:0] state;
    reg [2:0] next_state;

    reg rf_wr_en;
    reg is_wr_en; // Internal State
    reg [5:0] rf_wr_addr;
    reg [5:0] is_wr_addr;
    reg [5:0] rf_rd1_addr;
    reg [5:0] rf_rd2_addr;
    reg [5:0] is_rd1_addr;
    reg [5:0] is_rd2_addr;
    wire [DATA_W-1:0] rf_rd1_data;
    wire [DATA_W-1:0] is_rd1_data;
    wire [DATA_W-1:0] is_rd2_data;
    wire [DATA_W-1:0] rf_rd2_data;
    reg [DATA_W-1:0] rf_wr_data;
    reg [DATA_W-1:0] is_wr_data;

    wire is_wr_pl_en;
    reg [3:0] is_wr_pl;
    reg [3:0] is_pl;

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

    internal_state #(.DATA_W(DATA_W)) is (
        .clk(clk),
        .rst(rst),
        .wr_en(is_wr_en),
        .wr1_addr(is_wr_addr),
        .wr1_data(is_wr_data),
        .rd1_addr(is_rd1_addr),
        .rd1_out(is_rd1_data),
        .rd2_addr(is_rd2_addr),
        .rd2_out(is_rd2_data),
        .wr_pl_en(is_wr_pl_en),
        .wr_pl_data(is_wr_pl),
        .rd_pl_out(is_pl)
    );

    reg [DATA_W-1:0] pc;

    // Decoder
    reg [31:0] inst;
    reg [DATA_W-1:0] imm_in;
    reg imm_in_en;
    wire [11:0] opcode;
    wire [3:0] mode;
    wire [5:0] rsrc;
    wire [5:0] rdest;
    wire [3:0] flags;
    wire imm_en;
    wire decoded_valid;

    decoder dec (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .imm_in(imm_in),
        .imm_in_en(imm_in_en),
        .opcode(opcode),
        .mode(mode),
        .rsrc(rsrc),
        .rdest(rdest),
        .flags(flags),
        .imm_en(imm_en),
        .decoded_valid(decoded_valid)
    );

    wire inst_valid;
    wire regs_valid;
    assign inst_valid = (flags[0] != 1'b0);
    assign regs_valid = (rsrc < 40) && (rdest < 40);

    wire verify_ok;
    assign verify_ok = (inst_valid && regs_valid) ? 1'b1 : 1'b0;

    reg invalid_inst;

    reg using_alu;

    // Sequential
    always @(posedge clk) begin
        if (rst) begin // This will reset everything
            state <= ST_IDLE;
            locked <= 1'b0;
            in_use <= 1'b0;
            l1i_addr <= {DATA_W{1'b0}};
            l1d_addr <= {DATA_W{1'b0}};
            pc <= {DATA_W{1'b0}};
            invalid_inst <= 1'b0;
        end else if (thread_reset) begin // This will reset only the thread
            state <= ST_IDLE;
            locked <= 1'b0;
            in_use <= 1'b0;
            l1i_addr <= {DATA_W{1'b0}};
            l1d_addr <= {DATA_W{1'b0}};
            pc <= {DATA_W{1'b0}};
            invalid_inst <= 1'b0;
        end else begin
            if (enable && in_use == 1'b0)
                in_use <= 1'b1;
            state <= next_state;
        end
    end

    // Combinational
    always @(*) begin
        next_state = state;

        case (state)
            ST_IDLE: begin
                if (enable)
                    next_state = ST_FETCH;
            end

            ST_FETCH: begin
                next_state = ST_DECODE;
            end

            ST_DECODE: begin
                if (l1i_ready)
                    next_state = ST_VERIFY;
            end

            ST_VERIFY: begin
                if (verify_ok)
                    next_state = ST_EXECUTE;
                else
                    next_state = ST_LOCKED;
            end

            ST_EXECUTE: begin
                if (invalid_inst)
                    next_state = ST_LOCKED;
                else
                    next_state = ST_EXECUTE_P2;
            end

            ST_EXECUTE_P2: begin
                if (invalid_inst)
                    next_state = ST_LOCKED;
                else
                    next_state = ST_EXECUTE_P3;
            end

            ST_EXECUTE_P3: begin
                if (invalid_inst)
                    next_state = ST_LOCKED;
                else begin
                    if (using_alu && alu_done) begin
                        next_state = ST_FETCH;
                    end else if (!using_alu) begin
                        next_state = ST_FETCH;
                    end
                end
            end

            ST_LOCKED: begin
                if (verify_ok)
                    next_state = ST_VERIFY;
                else
                    next_state = ST_LOCKED;
            end

            default: begin
                next_state = ST_IDLE;
            end
        endcase
    end

    // Output and control
    always @(posedge clk) begin
        if (rst) begin
            alu_en <= 1'b0;
            read_l1i <= 1'b0;
            read_l1d <= 1'b0;
            locked <= 1'b0;
            alu_valid <= 1'b0;
            using_alu <= 1'b0;
            alu_a <= {DATA_W{1'b0}};
            alu_b <= {DATA_W{1'b0}};
        end else begin
            // defaults
            rf_wr_en <= 1'b0;
            read_l1i <= 1'b0;
            read_l1d <= 1'b0;
            alu_en <= 1'b0;

            case (state)
                ST_FETCH: begin
                    l1i_addr <= pc;
                    read_l1i <= 1'b1;
                end

                ST_DECODE: begin
                    if (l1i_ready) begin
                        inst <= l1i_data[31:0];
                        pc <= pc + 4;
                    end
                end

                ST_VERIFY: begin
                    if (!verify_ok)
                        locked <= 1'b1;
                end

                ST_EXECUTE: begin
                    $display("Opcode: %h Mode: %h Src: %h Dest: %h Flags: %h", opcode, mode, rsrc, rdest, flags);
                    if (opcode < 12'h100) begin // ALU
                        alu_op <= opcode[7:0];
                        if (mode == 4'h1) begin
                            rf_rd1_addr <= rdest;
                            rf_rd2_addr <= rsrc;
                        end else if (mode == 4'h2) begin
                            rf_rd1_addr <= rdest;
                            alu_b <= {58'd0, rsrc};
                        end else begin
                            alu_a <= {DATA_W{1'b0}};
                            alu_b <= {DATA_W{1'b0}};
                            invalid_inst <= 1'b1;
                        end
                        using_alu <= 1'b1;
                    end else begin
                        case (opcode)
                            12'h115: begin // MOV
                                if (mode == 4'h1) begin // REG TO REG
                                    rf_rd1_addr <= rsrc;
                                end else if (mode == 4'h2) begin // IMM (src) to REG
                                    rf_wr_en <= 1'b1;
                                    rf_wr_addr <= rdest;
                                    rf_wr_data <= {58'd0, rsrc};
                                end else begin
                                    invalid_inst <= 1'b1;
                                end
                            end
                            default: begin
                                invalid_inst <= 1'b1;
                            end
                        endcase
                    end
                end

                ST_EXECUTE_P2: begin
                    if (using_alu || opcode < 12'h100) begin
                        alu_en <= 1'b1;
                        alu_valid <= 1'b1;

                        if (mode == 4'h1) begin
                            alu_a <= rf_rd1_data;
                            alu_b <= rf_rd2_data;
                        end else if (mode == 4'h2) begin
                            alu_a <= rf_rd1_data;
                        end
                    end else begin
                        case (opcode)
                            12'h115: begin // MOV
                                if (mode == 4'h1) begin
                                    rf_wr_en <= 1'b1;
                                    rf_wr_data <= rf_rd1_data;
                                    rf_wr_addr <= rdest;
                                end
                            end
                        endcase
                    end
                end

                ST_EXECUTE_P3: begin
                    if (using_alu || opcode < 12'h100) begin
                        if (alu_done) begin
                            rf_wr_en <= 1'b1;
                            rf_wr_addr <= rdest;
                            rf_rd1_addr <= rdest;
                            rf_wr_data <= alu_res;
                            alu_valid <= 1'b0;
                            using_alu <= 1'b0;
                        end
                    end
                end

                ST_LOCKED: begin
                    if (verify_ok) // Allows unlocking incase of decoding wait
                        locked <= 1'b0;
                    else
                        locked <= 1'b1;
                end

            endcase
        end
    end

endmodule

