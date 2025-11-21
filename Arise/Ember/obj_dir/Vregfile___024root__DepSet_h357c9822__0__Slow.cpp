// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile.h for the primary calling header

#include "Vregfile__pch.h"
#include "Vregfile___024root.h"

VL_ATTR_COLD void Vregfile___024root___eval_static(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_static\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__regfile_test__DOT__clk__0 
        = vlSelfRef.regfile_test__DOT__clk;
    vlSelfRef.__Vtrigprevexpr_h73f15763__1 = (1U & 
                                              (~ (IData)(vlSelfRef.regfile_test__DOT__reset)));
}

VL_ATTR_COLD void Vregfile___024root___eval_initial__TOP(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_initial__TOP\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.regfile_test__DOT__clk = 0U;
}

VL_ATTR_COLD void Vregfile___024root___eval_final(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_final\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vregfile___024root___eval_settle(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_settle\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__act(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___dump_triggers__act\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge regfile_test.clk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @( (~ regfile_test.reset))\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__nba(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___dump_triggers__nba\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge regfile_test.clk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @( (~ regfile_test.reset))\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vregfile___024root___ctor_var_reset(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___ctor_var_reset\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->regfile_test__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9719343132377686041ull);
    vlSelf->regfile_test__DOT__reset = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3796851776891230054ull);
    vlSelf->regfile_test__DOT__wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8227050240827291662ull);
    vlSelf->regfile_test__DOT__wr1_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 3249164469087452018ull);
    vlSelf->regfile_test__DOT__wr1_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 14277612394165280164ull);
    vlSelf->regfile_test__DOT__rd1_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 417318040188471582ull);
    vlSelf->regfile_test__DOT__rd2_addr = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 6239942271392307845ull);
    vlSelf->regfile_test__DOT__rd2_out = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 16361245960264394892ull);
    vlSelf->regfile_test__DOT__temp_buf = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17423509222559561833ull);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->regfile_test__DOT__regs[__Vi0] = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 5501445989572567636ull);
    }
    vlSelf->regfile_test__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12620510296953671496ull);
    for (int __Vi0 = 0; __Vi0 < 19; ++__Vi0) {
        vlSelf->regfile_test__DOT__uut__DOT__regs[__Vi0] = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 4939876800229229116ull);
    }
    vlSelf->regfile_test__DOT__uut__DOT____Vlvbound_hdfb357cf__0 = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 8168893154279276942ull);
    vlSelf->__Vtrigprevexpr___TOP__regfile_test__DOT__clk__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15521805401794974297ull);
    vlSelf->__Vtrigprevexpr_h73f15763__1 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7631831534592981630ull);
    vlSelf->__VactDidInit = 0;
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
