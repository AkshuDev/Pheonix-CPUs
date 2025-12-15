// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcore_t.h for the primary calling header

#ifndef VERILATED_VCORE_T___024ROOT_H_
#define VERILATED_VCORE_T___024ROOT_H_  // guard

#include "verilated.h"


class Vcore_t__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vcore_t___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(reset,0,0);
        CData/*0:0*/ core_t__DOT__dut__DOT__fetched_valid;
        CData/*0:0*/ core_t__DOT__dut__DOT__fetched_imm_valid;
        CData/*3:0*/ core_t__DOT__dut__DOT__mode_out;
        CData/*5:0*/ core_t__DOT__dut__DOT__rsrc_out;
        CData/*5:0*/ core_t__DOT__dut__DOT__rdest_out;
        CData/*3:0*/ core_t__DOT__dut__DOT__flags_out;
        CData/*0:0*/ core_t__DOT__dut__DOT__imm_present;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_en;
        CData/*7:0*/ core_t__DOT__dut__DOT__alu_op;
        CData/*0:0*/ core_t__DOT__dut__DOT__mem_rd;
        CData/*0:0*/ core_t__DOT__dut__DOT__mem_wr;
        CData/*0:0*/ core_t__DOT__dut__DOT__reg_wr;
        CData/*0:0*/ core_t__DOT__dut__DOT__decoded_valid;
        CData/*0:0*/ core_t__DOT__dut__DOT__reg_we;
        CData/*5:0*/ core_t__DOT__dut__DOT__rwr_addr;
        CData/*5:0*/ core_t__DOT__dut__DOT__rsrc_addr;
        CData/*5:0*/ core_t__DOT__dut__DOT__rdest_addr;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_valid;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_carry;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_overflow;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_eq;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_lt;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_gt;
        CData/*0:0*/ core_t__DOT__dut__DOT__alu_flags;
        CData/*0:0*/ core_t__DOT__dut__DOT__dm_rd_en;
        CData/*0:0*/ core_t__DOT__dut__DOT__dm_wr_en;
        CData/*1:0*/ core_t__DOT__dut__DOT__state;
        CData/*3:0*/ core_t__DOT__dut__DOT__cur_mode;
        CData/*5:0*/ core_t__DOT__dut__DOT__cur_rsrc;
        CData/*5:0*/ core_t__DOT__dut__DOT__cur_rdest;
        CData/*3:0*/ core_t__DOT__dut__DOT__cur_flags;
        CData/*0:0*/ core_t__DOT__dut__DOT__cur_imm_present;
        CData/*0:0*/ core_t__DOT__dut__DOT__pending_imm_expected;
        CData/*0:0*/ core_t__DOT__dut__DOT__fetch_inst_valid_latched;
        CData/*0:0*/ core_t__DOT__dut__DOT__fetch_imm_valid_latched;
        CData/*0:0*/ core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __VactContinue;
        SData/*11:0*/ core_t__DOT__dut__DOT__opcode_out;
        SData/*11:0*/ core_t__DOT__dut__DOT__cur_opcode;
        IData/*31:0*/ core_t__DOT__load_program__Vstatic__i;
        IData/*31:0*/ core_t__DOT__dut__DOT__pc;
        IData/*31:0*/ core_t__DOT__dut__DOT__fetched_inst;
        IData/*31:0*/ core_t__DOT__dut__DOT__dm_addr;
        IData/*31:0*/ core_t__DOT__dut__DOT__i;
        IData/*31:0*/ core_t__DOT__dut__DOT__fetch_inst_latched;
        IData/*31:0*/ core_t__DOT__dut__DOT__dmem__DOT__i;
        IData/*31:0*/ __VactIterCount;
        QData/*63:0*/ core_t__DOT__dut__DOT__fetched_imm;
        QData/*63:0*/ core_t__DOT__dut__DOT__imm_out;
        QData/*63:0*/ core_t__DOT__dut__DOT__rsrc_data;
        QData/*63:0*/ core_t__DOT__dut__DOT__rdest_data;
        QData/*63:0*/ core_t__DOT__dut__DOT__wr_data;
        QData/*63:0*/ core_t__DOT__dut__DOT__alu_a;
        QData/*63:0*/ core_t__DOT__dut__DOT__alu_b;
        QData/*63:0*/ core_t__DOT__dut__DOT__alu_res;
        QData/*63:0*/ core_t__DOT__dut__DOT__dm_rd_data;
        QData/*63:0*/ core_t__DOT__dut__DOT__dm_wr_data;
        QData/*63:0*/ core_t__DOT__dut__DOT__cur_imm;
        QData/*63:0*/ core_t__DOT__dut__DOT__fetch_imm_latched;
        QData/*63:0*/ core_t__DOT__dut__DOT__rf__DOT____Vlvbound_hdb59fd83__0;
    };
    struct {
        VlUnpacked<CData/*7:0*/, 1024> core_t__DOT__dut__DOT__imem;
        VlUnpacked<QData/*63:0*/, 34> core_t__DOT__dut__DOT__rf__DOT__regs;
        VlUnpacked<QData/*63:0*/, 256> core_t__DOT__dut__DOT__dmem__DOT__mem;
        VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vcore_t__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vcore_t___024root(Vcore_t__Syms* symsp, const char* v__name);
    ~Vcore_t___024root();
    VL_UNCOPYABLE(Vcore_t___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
