// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_t.h for the primary calling header

#include "Vcore_t__pch.h"
#include "Vcore_t__Syms.h"
#include "Vcore_t___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__act(Vcore_t___024root* vlSelf);
#endif  // VL_DEBUG

void Vcore_t___024root___eval_triggers__act(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_triggers__act\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.setBit(0U, ((IData)(vlSelfRef.clk) 
                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcore_t___024root___dump_triggers__act(vlSelf);
    }
#endif
}
