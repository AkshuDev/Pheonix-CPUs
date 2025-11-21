`timescale 1ns/1ps

module core (
   input wire clk,
   input wire reset
);
    reg [31:0] pc;
    reg [7:0] imem [0:1023]; // 1 KB of Instruction memory

    reg [31:0] fetched_inst;
    reg fetched_valid;
    reg [63:0] fetched_imm;
    reg fetched_imm_valid;

    wire [11:0] opcode_out;
    wire [3:0] mode_out;
    wire [5:0] rsrc_out, rdest_out;
    wire [3:0] flags_out;
    wire [63:0] imm_out;
    wire imm_present;
    wire alu_en;
    wire [7:0] alu_op;
    wire mem_rd;
    wire mem_wr;
    wire reg_wr;
    wire decoded_valid;

    decoder dec(
        .clk(clk),
        .rst(reset),
        .inst(fetched_inst),
        .imm_in(fetched_imm),
        .imm_in_en(fetched_imm_valid),
        .opcode(opcode_out),
        .mode(mode_out),
        .rsrc(rsrc_out),
        .rdest(rdest_out),
        .flags(flags_out),
        .imm(imm_out),
        .imm_en(imm_present),
        .alu_op(alu_op),
        .alu_en(alu_en),
        .mem_read(mem_rd),
        .mem_write(mem_wr),
        .reg_write(reg_wr),
        .decoded_valid(decoded_valid)
    );

    wire [63:0] rsrc_data, rdest_data;
    reg reg_we;
    reg [5:0] rwr_addr;
    reg [63:0] wr_data;
    reg [5:0] rsrc_addr, rdest_addr;

    regfile rf (
        .clk(clk),
        .rst(reset),
        .wr_en(reg_we),
        .wr1_addr(rwr_addr),
        .wr1_data(wr_data),
        .rd1_addr(rsrc_addr),
        .rd1_out(rsrc_data),
        .rd2_addr(rdest_addr),
        .rd2_out(rdest_data)
    );

    reg alu_valid;
    reg [63:0] alu_a, alu_b;
    wire [63:0] alu_res;
    wire alu_zero, alu_carry, alu_overflow;
    wire alu_eq, alu_lt, alu_gt;

    reg alu_flags;

    alu alu_mod(
        .clk(clk),
        .rst(reset),
        .a(alu_a),
        .b(alu_b),
        .res(alu_res),
        .zero(alu_zero),
        .carry(alu_carry),
        .overflow(alu_overflow),
        .eq(alu_eq),
        .lt(alu_lt),
        .gt(alu_gt),
        .valid(alu_valid),
        .op(alu_op)
    );

    wire [63:0] dm_rd_data;
    reg dm_rd_en, dm_wr_en;
    reg [31:0] dm_addr;
    reg [63:0] dm_wr_data;
    mem #(.DEPTH(256)) dmem (
        .clk(clk),
        .rst(reset),
        .rd_en(dm_rd_en),
        .wr_en(dm_wr_en),
        .byte_addr(dm_addr),
        .wr_data(dm_wr_data),
        .rd_data(dm_rd_data)
    );

    localparam[63:0] FIXED_MEM_BASE = 64'h0000_0000_0000_1000;
    
    typedef enum reg [1:0] {S_FETCH=2'b00, S_WAIT_DEC=2'b01, S_EXEC=2'b10} state_t;
    reg [1:0] state;

    reg [11:0] cur_opcode;
    reg [3:0] cur_mode;
    reg [5:0] cur_rsrc, cur_rdest;
    reg [3:0] cur_flags;
    reg [63:0] cur_imm;
    reg cur_imm_present;
    integer i;

    initial begin
        for(i=0;i<1024;i=i+1) imem[i] = 8'h00;
    end

    reg pending_imm_expected;
    reg [31:0] fetch_inst_latched;
    reg fetch_inst_valid_latched;
    reg [63:0] fetch_imm_latched;
    reg fetch_imm_valid_latched;

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
            fetched_valid <= 1'b0;
            fetched_imm_valid <= 1'b0;
            pending_imm_expected <= 1'b0;
        end else begin
            fetched_valid <= 1'b0;
            fetched_imm_valid <= 1'b0;

            if (!pending_imm_expected) begin
                fetch_inst_latched[7:0] = imem[pc + 0];
                fetch_inst_latched[15:8] = imem[pc + 1];
                fetch_inst_latched[23:16] = imem[pc + 2];
                fetch_inst_latched[31:24] = imem[pc + 3];

                fetched_inst <= fetch_inst_latched;
                fetched_valid <= 1'b1;

                if (fetch_inst_latched[3]) begin
                    pending_imm_expected <= 1'b1;
                    pc <= pc + 4;
                end else begin
                    pc <= pc + 4;
                end
            end else begin
                fetch_imm_latched[7:0] = imem[pc + 0];
                fetch_imm_latched[15:8] = imem[pc + 1];
                fetch_imm_latched[23:16] = imem[pc + 2];
                fetch_imm_latched[31:24] = imem[pc + 3];
                fetch_imm_latched[39:32] = imem[pc + 4];
                fetch_imm_latched[47:40] = imem[pc + 5];
                fetch_imm_latched[55:48] = imem[pc + 6];
                fetch_imm_latched[63:56] = imem[pc + 7];

                fetched_imm <= fetch_imm_latched;
                fetched_imm_valid <= 1'b1;
                pending_imm_expected <= 1'b0;

                pc <= pc + 8;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S_FETCH;
            reg_we <= 1'b0;
            dm_rd_en <= 0;
            dm_wr_en <= 0;
            alu_valid <= 0;
        end else begin
            reg_we <= 1'b0;
            dm_rd_en <= 1'b0;
            dm_wr_en <= 1'b0;
            alu_valid <= 1'b0;

            case (state) 
                S_FETCH: begin
                    if (decoded_valid) begin
                        cur_opcode <= opcode_out;
                        cur_mode <= mode_out;
                        cur_rsrc <= rsrc_out;
                        cur_rdest <= rdest_out;
                        cur_flags <= flags_out;
                        cur_imm <= imm_out;
                        cur_imm_present <= imm_present;
                        state <= S_EXEC;
                    end
                end

                S_EXEC: begin
                    // Default values each cycle
                    reg_we   <= 1'b0;
                    alu_valid <= 1'b0;
                    dm_rd_en <= 1'b0;
                    dm_wr_en <= 1'b0;

                    // ALU opcode range
                    if (cur_opcode < 12'h100) begin
                        // Simple ALU ops (ADD, SUB, OR, AND...)
                        rsrc_addr <= cur_rsrc;
                        rdest_addr <= cur_rdest;

                        alu_a <= rsrc_data;
                        alu_b <= rdest_data;
                        alu_valid <= 1'b1;

                        reg_we   <= 1'b1;
                        wr_data  <= alu_res;
                        rwr_addr <= cur_rdest;

                        state <= S_FETCH;

                    end else begin
                        case (cur_opcode)

                            // -----------------------------
                            // LOAD_FIXED  (opcode 0x100)
                            // -----------------------------
                            12'h100: begin
                                if (cur_imm_present)
                                    dm_addr <= cur_imm[31:0];
                                else
                                    dm_addr <= FIXED_MEM_BASE[31:0];

                                dm_rd_en <= 1'b1;

                                // write to destination register after read
                                reg_we   <= 1'b1;
                                rwr_addr <= cur_rdest;
                                wr_data  <= dm_rd_data;

                                state <= S_FETCH;
                            end

                            // -----------------------------
                            // STORE_FIXED  (opcode 0x101)
                            // store rsrc → memory
                            // -----------------------------
                            12'h101: begin
                                rsrc_addr <= cur_rsrc;

                                if (cur_imm_present)
                                    dm_addr <= cur_imm[31:0];
                                else
                                    dm_addr <= FIXED_MEM_BASE[31:0];

                                dm_wr_en  <= 1'b1;
                                dm_wr_data <= rsrc_data;

                                state <= S_FETCH;
                            end

                            default: begin
                                // Unknown opcode → just continue
                                state <= S_FETCH;
                            end
                        endcase
                    end
                end

                default: state <= S_FETCH;
            endcase
        end
    end
endmodule

