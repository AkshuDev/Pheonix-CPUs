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
    input wire [DATA_W-1:0] l1d_data [0:7],
    input wire l1d_ready,

    // L1-I
    output reg read_l1i,
    output reg [DATA_W-1:0] l1i_addr,
    input wire [DATA_W-1:0] l1i_data [0:7],
    input wire l1i_ready
);
    localparam ST_IDLE = 4'd0;
    localparam ST_FETCH = 4'd1;
    localparam ST_DECODE = 4'd2;
    localparam ST_VERIFY = 4'd3;
    localparam ST_EXECUTE = 4'd4;
    localparam ST_EXECUTE_P2 = 4'd5;
    localparam ST_EXECUTE_P3 = 4'd6;
    localparam ST_LOCKED = 4'd7;

    localparam LINE_SIZE = 8;
    localparam LINE_BYTES = LINE_SIZE * 8;
    localparam NUM_LINES = DATA_W / LINE_BYTES;
    
    reg [3:0] state;
    reg [3:0] next_state;

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

    reg [DATA_W-1:0] pc;
    reg write_pc;
    reg [DATA_W-1:0] pc_wr_data;

    reg [DATA_W-1:0] l1i_start;
    reg [DATA_W-1:0] l1i_end;

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
        .rd_pl_out(is_pl),
        .wr_pc(write_pc),
        .pc_data(pc_wr_data),
        .pc_out(pc)
    );

    // Decoder
    reg [31:0] inst;
    reg [DATA_W-1:0] data;

    wire [11:0] opcode;
    wire [3:0] mode;
    wire [5:0] rsrc;
    wire [5:0] rdest;
    wire [3:0] flags;
    wire [DATA_W-1:0] imm64, disp64, ext64;
    wire imm_present, disp_present, ext_present;
    wire decoded_valid, finished_decoding;

    decoder dec (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .data(data),

        .opcode(opcode),
        .mode(mode),
        .rsrc(rsrc),
        .rdest(rdest),
        .flags(flags),
        .imm(imm64),
        .disp(disp64),
        .ext(ext64),

        .imm_present(imm_present),
        .disp_present(disp_present),
        .ext_present(ext_present),

        .finished_decoding(finished_decoding),
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
            invalid_inst <= 1'b0;
            l1i_start <= {DATA_W{1'b0}};
            l1i_end <= {DATA_W{1'b0}};
        end else if (thread_reset) begin // This will reset only the thread
            state <= ST_IDLE;
            locked <= 1'b0;
            in_use <= 1'b0;
            l1i_addr <= {DATA_W{1'b0}};
            l1d_addr <= {DATA_W{1'b0}};
            invalid_inst <= 1'b0;
            l1i_start <= {DATA_W{1'b0}};
            l1i_end <= {DATA_W{1'b0}};
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
                if (finished_decoding)
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

    reg need_l1i;
    reg [31:0] inst_consumed_bytes;

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
            need_l1i <= 1'b0;
            read_l1d <= 1'b0;
            inst <= {DATA_W{1'b0}};
            data <= {DATA_W{1'b0}};
            inst_consumed_bytes <= 0;
        end else begin
            // defaults
            rf_wr_en <= 1'b0;
            alu_en <= 1'b0;
            write_pc <= 1'b0;

            case (state)
                ST_FETCH: begin
                    inst_consumed_bytes <= 0;
                    l1i_addr <= pc;
                    if (pc + 4 > l1i_end) begin
                        read_l1i <= 1'b1;
                        l1i_start <= pc;
                        l1i_end <= pc + LINE_BYTES;
                        need_l1i <= 1'b1;
                    end else begin
                        need_l1i <= 1'b0;
                    end
                end

                ST_DECODE: begin
                    if ((need_l1i && l1i_ready) || !need_l1i) begin
                        if (need_l1i && l1i_ready) begin
                            read_l1i <= 1'b0;
                        end

                        if (inst_consumed_bytes == 0) begin
                            inst_consumed_bytes <= 4;
                            inst <= l1i_data[pc / LINE_BYTES][31:0];
                            
                            if (need_l1i)
                                need_l1i <= 1'b0;
                            write_pc <= 1'b1;
                            pc_wr_data <= pc + 4;
                        end

                        if (!finished_decoding && inst_consumed_bytes > 0) begin
                            if (!read_l1d) begin
                                read_l1d <= 1'b1;
                                l1d_addr <= pc;
                            end else if (read_l1d && l1d_ready) begin
                                read_l1d <= 1'b0;
                                write_pc <= 1'b1;
                                pc_wr_data <= pc + 8;
                                inst_consumed_bytes <= inst_consumed_bytes + 8;
                                data <= l1d_data[pc / LINE_BYTES];
                            end
                        end
                    end
                end

                ST_VERIFY: begin
                    if (!verify_ok)
                        locked <= 1'b1;
                end

                ST_EXECUTE: begin
                    $display("\tPC: %h", pc);
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
                                end else if (mode == 4'h3) begin // IMM to REG
                                    rf_wr_en <= 1'b1;
                                    rf_wr_addr <= rdest;
                                    rf_wr_data <= imm64;
                                end else if (mode == 4'h4) begin // DISP + PC to REG
                                    rf_wr_en <= 1'b1;
                                    rf_wr_addr <= rdest;
                                    rf_wr_data <= disp64 + (pc - inst_consumed_bytes);
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

