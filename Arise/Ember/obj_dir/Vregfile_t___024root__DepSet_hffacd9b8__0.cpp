// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile_t.h for the primary calling header

#include "Vregfile_t__pch.h"
#include "Vregfile_t__Syms.h"
#include "Vregfile_t___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile_t___024root___dump_triggers__act(Vregfile_t___024root* vlSelf);
#endif  // VL_DEBUG

void Vregfile_t___024root___eval_triggers__act(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_triggers__act\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __Vtrigprevexpr_hf1eca039__0;
    __Vtrigprevexpr_hf1eca039__0 = 0;
    // Body
    __Vtrigprevexpr_hf1eca039__0 = (1U & (~ (IData)(vlSelfRef.reset)));
    vlSelfRef.__VactTriggered.setBit(0U, ((IData)(vlSelfRef.clk) 
                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))));
    vlSelfRef.__VactTriggered.setBit(1U, ((IData)(__Vtrigprevexpr_hf1eca039__0) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr_hf1eca039__1)));
    vlSelfRef.__VactTriggered.setBit(2U, vlSelfRef.__VdlySched.awaitingCurrentTime());
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr_hf1eca039__1 = __Vtrigprevexpr_hf1eca039__0;
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VactDidInit)))))) {
        vlSelfRef.__VactDidInit = 1U;
        vlSelfRef.__VactTriggered.setBit(1U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vregfile_t___024root___dump_triggers__act(vlSelf);
    }
#endif
}
