// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vregfile_t.h for the primary calling header

#ifndef VERILATED_VREGFILE_T___024ROOT_H_
#define VERILATED_VREGFILE_T___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vregfile_t__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vregfile_t___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    CData/*0:0*/ regfile_test__DOT__wr_en;
    CData/*4:0*/ regfile_test__DOT__wr1_addr;
    CData/*4:0*/ regfile_test__DOT__rd1_addr;
    CData/*4:0*/ regfile_test__DOT__rd2_addr;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr_hf1eca039__1;
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
    VlUnpacked<CData/*0:0*/, 4> __Vm_traceActivity;
    VlTriggerScheduler __VtrigSched_h75db2e5c__0;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_ha2a3c242__0;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vregfile_t__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vregfile_t___024root(Vregfile_t__Syms* symsp, const char* v__name);
    ~Vregfile_t___024root();
    VL_UNCOPYABLE(Vregfile_t___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
