// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile.h for the primary calling header

#include "Vregfile__pch.h"
#include "Vregfile__Syms.h"
#include "Vregfile___024root.h"

VL_INLINE_OPT VlCoroutine Vregfile___024root___eval_initial__TOP__Vtiming__2(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_initial__TOP__Vtiming__2\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__VdlySched.delay(0x1388ULL, 
                                             nullptr, 
                                             "regfile_t.v", 
                                             42);
        vlSelfRef.regfile_test__DOT__clk = (1U & (~ (IData)(vlSelfRef.regfile_test__DOT__clk)));
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__act(Vregfile___024root* vlSelf);
#endif  // VL_DEBUG

void Vregfile___024root___eval_triggers__act(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_triggers__act\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __Vtrigprevexpr_h73f15763__0;
    __Vtrigprevexpr_h73f15763__0 = 0;
    // Body
    __Vtrigprevexpr_h73f15763__0 = (1U & (~ (IData)(vlSelfRef.regfile_test__DOT__reset)));
    vlSelfRef.__VactTriggered.setBit(0U, ((IData)(vlSelfRef.regfile_test__DOT__clk) 
                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__regfile_test__DOT__clk__0))));
    vlSelfRef.__VactTriggered.setBit(1U, vlSelfRef.__VdlySched.awaitingCurrentTime());
    vlSelfRef.__VactTriggered.setBit(2U, ((IData)(__Vtrigprevexpr_h73f15763__0) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr_h73f15763__1)));
    vlSelfRef.__Vtrigprevexpr___TOP__regfile_test__DOT__clk__0 
        = vlSelfRef.regfile_test__DOT__clk;
    vlSelfRef.__Vtrigprevexpr_h73f15763__1 = __Vtrigprevexpr_h73f15763__0;
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VactDidInit)))))) {
        vlSelfRef.__VactDidInit = 1U;
        vlSelfRef.__VactTriggered.setBit(2U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vregfile___024root___dump_triggers__act(vlSelf);
    }
#endif
}
