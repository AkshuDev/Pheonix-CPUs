// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile_t.h for the primary calling header

#include "Vregfile_t__pch.h"
#include "Vregfile_t___024root.h"

VL_ATTR_COLD void Vregfile_t___024root___eval_initial__TOP(Vregfile_t___024root* vlSelf);
VlCoroutine Vregfile_t___024root___eval_initial__TOP__Vtiming__0(Vregfile_t___024root* vlSelf);

void Vregfile_t___024root___eval_initial(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_initial\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vregfile_t___024root___eval_initial__TOP(vlSelf);
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    Vregfile_t___024root___eval_initial__TOP__Vtiming__0(vlSelf);
}

VL_INLINE_OPT VlCoroutine Vregfile_t___024root___eval_initial__TOP__Vtiming__0(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (vlSelfRef.reset) {
        co_await vlSelfRef.__VtrigSched_h75db2e5c__0.trigger(1U, 
                                                             nullptr, 
                                                             "@( (~ reset))", 
                                                             "regfile_t.v", 
                                                             49);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
    }
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__wr1_addr = 0U;
    vlSelfRef.regfile_test__DOT__wr1_data = 0xdeadbeefcafebabeULL;
    co_await vlSelfRef.__VdlySched.delay(0x2710ULL, 
                                         nullptr, "regfile_t.v", 
                                         54);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 0U;
    co_await vlSelfRef.__VdlySched.delay(0x2710ULL, 
                                         nullptr, "regfile_t.v", 
                                         56);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__wr1_addr = 1U;
    vlSelfRef.regfile_test__DOT__wr1_data = 0x123456789abcdefULL;
    co_await vlSelfRef.__VdlySched.delay(0x2710ULL, 
                                         nullptr, "regfile_t.v", 
                                         61);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 0U;
    vlSelfRef.regfile_test__DOT__i = 0U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 1U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 2U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 3U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 4U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 5U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 6U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 7U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 8U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 9U;
    co_await vlSelfRef.__VtrigSched_ha2a3c242__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge clk)", 
                                                         "regfile_t.v", 
                                                         66);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.regfile_test__DOT__wr_en = 1U;
    vlSelfRef.regfile_test__DOT__temp_buf = (0x1fU 
                                             & VL_RANDOM_I());
    vlSelfRef.regfile_test__DOT__wr1_addr = (0x1fU 
                                             & vlSelfRef.regfile_test__DOT__temp_buf);
    vlSelfRef.regfile_test__DOT__wr1_data = (QData)((IData)(
                                                            VL_RANDOM_I()));
    vlSelfRef.regfile_test__DOT__i = 0xaU;
    vlSelfRef.regfile_test__DOT__wr_en = 0U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
}

void Vregfile_t___024root___eval_act(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_act\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vregfile_t___024root___nba_sequent__TOP__0(Vregfile_t___024root* vlSelf);

void Vregfile_t___024root___eval_nba(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_nba\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vregfile_t___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
    }
}

VL_INLINE_OPT void Vregfile_t___024root___nba_sequent__TOP__0(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___nba_sequent__TOP__0\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VdlySet__regfile_test__DOT__uut__DOT__regs__v0;
    __VdlySet__regfile_test__DOT__uut__DOT__regs__v0 = 0;
    QData/*63:0*/ __VdlyVal__regfile_test__DOT__uut__DOT__regs__v3;
    __VdlyVal__regfile_test__DOT__uut__DOT__regs__v3 = 0;
    CData/*4:0*/ __VdlyDim0__regfile_test__DOT__uut__DOT__regs__v3;
    __VdlyDim0__regfile_test__DOT__uut__DOT__regs__v3 = 0;
    CData/*0:0*/ __VdlySet__regfile_test__DOT__uut__DOT__regs__v3;
    __VdlySet__regfile_test__DOT__uut__DOT__regs__v3 = 0;
    // Body
    __VdlySet__regfile_test__DOT__uut__DOT__regs__v0 = 0U;
    __VdlySet__regfile_test__DOT__uut__DOT__regs__v3 = 0U;
    if (vlSelfRef.reset) {
        __VdlySet__regfile_test__DOT__uut__DOT__regs__v0 = 1U;
    } else if (((IData)(vlSelfRef.regfile_test__DOT__wr_en) 
                & (0U != (IData)(vlSelfRef.regfile_test__DOT__wr1_addr)))) {
        if ((0x13U > (IData)(vlSelfRef.regfile_test__DOT__wr1_addr))) {
            vlSelfRef.regfile_test__DOT__uut__DOT____Vlvbound_hdfb357cf__0 
                = vlSelfRef.regfile_test__DOT__wr1_data;
            if ((0x12U >= (IData)(vlSelfRef.regfile_test__DOT__wr1_addr))) {
                __VdlyVal__regfile_test__DOT__uut__DOT__regs__v3 
                    = vlSelfRef.regfile_test__DOT__uut__DOT____Vlvbound_hdfb357cf__0;
                __VdlyDim0__regfile_test__DOT__uut__DOT__regs__v3 
                    = vlSelfRef.regfile_test__DOT__wr1_addr;
                __VdlySet__regfile_test__DOT__uut__DOT__regs__v3 = 1U;
            }
        }
    }
    if (__VdlySet__regfile_test__DOT__uut__DOT__regs__v0) {
        vlSelfRef.regfile_test__DOT__uut__DOT__regs[0x10U] = 0ULL;
        vlSelfRef.regfile_test__DOT__uut__DOT__regs[0x11U] = 0ULL;
        vlSelfRef.regfile_test__DOT__uut__DOT__regs[0x12U] = 0xffffULL;
    }
    if (__VdlySet__regfile_test__DOT__uut__DOT__regs__v3) {
        vlSelfRef.regfile_test__DOT__uut__DOT__regs[__VdlyDim0__regfile_test__DOT__uut__DOT__regs__v3] 
            = __VdlyVal__regfile_test__DOT__uut__DOT__regs__v3;
    }
}

void Vregfile_t___024root___timing_resume(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___timing_resume\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VtrigSched_h75db2e5c__0.resume(
                                                   "@( (~ reset))");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VtrigSched_ha2a3c242__0.resume(
                                                   "@(posedge clk)");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vregfile_t___024root___timing_commit(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___timing_commit\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((! (2ULL & vlSelfRef.__VactTriggered.word(0U)))) {
        vlSelfRef.__VtrigSched_h75db2e5c__0.commit(
                                                   "@( (~ reset))");
    }
    if ((! (1ULL & vlSelfRef.__VactTriggered.word(0U)))) {
        vlSelfRef.__VtrigSched_ha2a3c242__0.commit(
                                                   "@(posedge clk)");
    }
}

void Vregfile_t___024root___eval_triggers__act(Vregfile_t___024root* vlSelf);

bool Vregfile_t___024root___eval_phase__act(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_phase__act\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<3> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vregfile_t___024root___eval_triggers__act(vlSelf);
    Vregfile_t___024root___timing_commit(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vregfile_t___024root___timing_resume(vlSelf);
        Vregfile_t___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vregfile_t___024root___eval_phase__nba(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_phase__nba\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vregfile_t___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile_t___024root___dump_triggers__nba(Vregfile_t___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile_t___024root___dump_triggers__act(Vregfile_t___024root* vlSelf);
#endif  // VL_DEBUG

void Vregfile_t___024root___eval(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vregfile_t___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("regfile_t.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vregfile_t___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("regfile_t.v", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vregfile_t___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vregfile_t___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vregfile_t___024root___eval_debug_assertions(Vregfile_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root___eval_debug_assertions\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY(((vlSelfRef.reset & 0xfeU)))) {
        Verilated::overWidthError("reset");}
}
#endif  // VL_DEBUG
