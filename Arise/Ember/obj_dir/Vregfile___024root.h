// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vregfile.h for the primary calling header

#ifndef VERILATED_VREGFILE___024ROOT_H_
#define VERILATED_VREGFILE___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vregfile__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vregfile___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ regfile_test__DOT__clk;
    CData/*0:0*/ regfile_test__DOT__reset;
    CData/*0:0*/ regfile_test__DOT__wr_en;
    CData/*4:0*/ regfile_test__DOT__wr1_addr;
    CData/*4:0*/ regfile_test__DOT__rd1_addr;
    CData/*4:0*/ regfile_test__DOT__rd2_addr;
    CData/*0:0*/ __Vtrigprevexpr___TOP__regfile_test__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr_h73f15763__1;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ regfile_test__DOT__temp_buf;
    IData/*31:0*/ regfile_test__DOT__i;
    IData/*31:0*/ __VactIterCount;
    QData/*63:0*/ regfile_test__DOT__wr1_data;
    QData/*63:0*/ regfile_test__DOT__rd2_out;
    QData/*63:0*/ regfile_test__DOT__uut__DOT____Vlvbound_hdfb357cf__0;
    VlUnpacked<QData/*63:0*/, 32> regfile_test__DOT__regs;
    VlUnpacked<QData/*63:0*/, 19> regfile_test__DOT__uut__DOT__regs;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_hf3c6e47e__0;
    VlTriggerScheduler __VtrigSched_h0b12d9d8__0;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vregfile__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vregfile___024root(Vregfile__Syms* symsp, const char* v__name);
    ~Vregfile___024root();
    VL_UNCOPYABLE(Vregfile___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
