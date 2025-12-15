// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_t.h for the primary calling header

#include "Vcore_t__pch.h"
#include "Vcore_t___024root.h"

VL_ATTR_COLD void Vcore_t___024root___eval_static(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_static\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vcore_t___024root___eval_initial__TOP(Vcore_t___024root* vlSelf);

VL_ATTR_COLD void Vcore_t___024root___eval_initial(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_initial\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vcore_t___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vcore_t___024root___eval_initial__TOP(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_initial__TOP\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_WRITEF_NX("=== CORE TESTBENCH START ===\n[%0t] Reset Deasserted\n",0,
                 64,VL_TIME_UNITED_Q(1000),-9);
    vlSelfRef.core_t__DOT__dut__DOT__imem[0U] = 1U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[1U] = 0x12U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[2U] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[3U] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[4U] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[5U] = 1U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[6U] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[7U] = 8U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[8U] = 0x34U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[9U] = 0x12U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xaU] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xbU] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xcU] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xdU] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xeU] = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__imem[0xfU] = 0U;
    VL_WRITEF_NX("PROGRAM LOADED.\n=== CORE TESTBENCH END ===\n",0);
    VL_FINISH_MT("core_t.v", 69, "");
}

VL_ATTR_COLD void Vcore_t___024root___eval_final(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_final\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__stl(Vcore_t___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vcore_t___024root___eval_phase__stl(Vcore_t___024root* vlSelf);

VL_ATTR_COLD void Vcore_t___024root___eval_settle(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_settle\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vcore_t___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("core_t.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vcore_t___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__stl(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___dump_triggers__stl\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcore_t___024root___stl_sequent__TOP__0(Vcore_t___024root* vlSelf);
VL_ATTR_COLD void Vcore_t___024root____Vm_traceActivitySetAll(Vcore_t___024root* vlSelf);

VL_ATTR_COLD void Vcore_t___024root___eval_stl(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_stl\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vcore_t___024root___stl_sequent__TOP__0(vlSelf);
        Vcore_t___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD void Vcore_t___024root___stl_sequent__TOP__0(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___stl_sequent__TOP__0\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.core_t__DOT__dut__DOT__rsrc_data = ((
                                                   (0x22U 
                                                    > (IData)(vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr)) 
                                                   & (0U 
                                                      != (IData)(vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr)))
                                                   ? 
                                                  ((0x21U 
                                                    >= (IData)(vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr))
                                                    ? 
                                                   vlSelfRef.core_t__DOT__dut__DOT__rf__DOT__regs
                                                   [vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr]
                                                    : 0ULL)
                                                   : 0ULL);
}

VL_ATTR_COLD void Vcore_t___024root___eval_triggers__stl(Vcore_t___024root* vlSelf);

VL_ATTR_COLD bool Vcore_t___024root___eval_phase__stl(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_phase__stl\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vcore_t___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vcore_t___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__act(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___dump_triggers__act\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__nba(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___dump_triggers__nba\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcore_t___024root____Vm_traceActivitySetAll(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root____Vm_traceActivitySetAll\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
}

VL_ATTR_COLD void Vcore_t___024root___ctor_var_reset(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___ctor_var_reset\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->reset = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9928399931838511862ull);
    vlSelf->core_t__DOT__load_program__Vstatic__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4762545527661691898ull);
    vlSelf->core_t__DOT__dut__DOT__pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 2866329616051865863ull);
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->core_t__DOT__dut__DOT__imem[__Vi0] = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 13268431074004697711ull);
    }
    vlSelf->core_t__DOT__dut__DOT__fetched_inst = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 5508928801029287582ull);
    vlSelf->core_t__DOT__dut__DOT__fetched_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16573721384885335297ull);
    vlSelf->core_t__DOT__dut__DOT__fetched_imm = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 12916692310689009183ull);
    vlSelf->core_t__DOT__dut__DOT__fetched_imm_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6288629477229679010ull);
    vlSelf->core_t__DOT__dut__DOT__opcode_out = VL_SCOPED_RAND_RESET_I(12, __VscopeHash, 13891633283554230947ull);
    vlSelf->core_t__DOT__dut__DOT__mode_out = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 11532761601445673615ull);
    vlSelf->core_t__DOT__dut__DOT__rsrc_out = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 2705283028665398127ull);
    vlSelf->core_t__DOT__dut__DOT__rdest_out = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 15774971648891696478ull);
    vlSelf->core_t__DOT__dut__DOT__flags_out = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 8812686155690807815ull);
    vlSelf->core_t__DOT__dut__DOT__imm_out = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 2103417870685372861ull);
    vlSelf->core_t__DOT__dut__DOT__imm_present = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8788165416287508928ull);
    vlSelf->core_t__DOT__dut__DOT__alu_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3232163197541051465ull);
    vlSelf->core_t__DOT__dut__DOT__alu_op = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 15817476607104226984ull);
    vlSelf->core_t__DOT__dut__DOT__mem_rd = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10342430352553712778ull);
    vlSelf->core_t__DOT__dut__DOT__mem_wr = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14778448156060771822ull);
    vlSelf->core_t__DOT__dut__DOT__reg_wr = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6125954394952013457ull);
    vlSelf->core_t__DOT__dut__DOT__decoded_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12814072715168917472ull);
    vlSelf->core_t__DOT__dut__DOT__rsrc_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 904493714572235910ull);
    vlSelf->core_t__DOT__dut__DOT__rdest_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 3121993793779374460ull);
    vlSelf->core_t__DOT__dut__DOT__reg_we = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1087306293563487681ull);
    vlSelf->core_t__DOT__dut__DOT__rwr_addr = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 8781801647705378490ull);
    vlSelf->core_t__DOT__dut__DOT__wr_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 5793579227188259812ull);
    vlSelf->core_t__DOT__dut__DOT__rsrc_addr = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 14175433487599530324ull);
    vlSelf->core_t__DOT__dut__DOT__rdest_addr = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 14408753239208788194ull);
    vlSelf->core_t__DOT__dut__DOT__alu_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3343870891603134982ull);
    vlSelf->core_t__DOT__dut__DOT__alu_a = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 11772833560994526544ull);
    vlSelf->core_t__DOT__dut__DOT__alu_b = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 10960244923549727389ull);
    vlSelf->core_t__DOT__dut__DOT__alu_res = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 1077320308634987544ull);
    vlSelf->core_t__DOT__dut__DOT__alu_carry = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1477955668002690475ull);
    vlSelf->core_t__DOT__dut__DOT__alu_overflow = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1010486146620296557ull);
    vlSelf->core_t__DOT__dut__DOT__alu_eq = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11942972067883104244ull);
    vlSelf->core_t__DOT__dut__DOT__alu_lt = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13386717508479496332ull);
    vlSelf->core_t__DOT__dut__DOT__alu_gt = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5116150112749390526ull);
    vlSelf->core_t__DOT__dut__DOT__alu_flags = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12309916693271785079ull);
    vlSelf->core_t__DOT__dut__DOT__dm_rd_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 15662186044202908474ull);
    vlSelf->core_t__DOT__dut__DOT__dm_rd_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4323238243046370342ull);
    vlSelf->core_t__DOT__dut__DOT__dm_wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6964295113664835776ull);
    vlSelf->core_t__DOT__dut__DOT__dm_addr = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8399466937613305694ull);
    vlSelf->core_t__DOT__dut__DOT__dm_wr_data = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 16017349087530608932ull);
    vlSelf->core_t__DOT__dut__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 2536146529517636263ull);
    vlSelf->core_t__DOT__dut__DOT__cur_opcode = VL_SCOPED_RAND_RESET_I(12, __VscopeHash, 18402026347081325081ull);
    vlSelf->core_t__DOT__dut__DOT__cur_mode = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 7423028807158668827ull);
    vlSelf->core_t__DOT__dut__DOT__cur_rsrc = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 4555473367210771344ull);
    vlSelf->core_t__DOT__dut__DOT__cur_rdest = VL_SCOPED_RAND_RESET_I(6, __VscopeHash, 11729447529550954968ull);
    vlSelf->core_t__DOT__dut__DOT__cur_flags = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 11788692183828704121ull);
    vlSelf->core_t__DOT__dut__DOT__cur_imm = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 3443583898773549498ull);
    vlSelf->core_t__DOT__dut__DOT__cur_imm_present = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14458284911945664334ull);
    vlSelf->core_t__DOT__dut__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 670056911827599158ull);
    vlSelf->core_t__DOT__dut__DOT__pending_imm_expected = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1942377899259717277ull);
    vlSelf->core_t__DOT__dut__DOT__fetch_inst_latched = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4694843969737585630ull);
    vlSelf->core_t__DOT__dut__DOT__fetch_inst_valid_latched = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6286930213236628330ull);
    vlSelf->core_t__DOT__dut__DOT__fetch_imm_latched = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 18224825104746299069ull);
    vlSelf->core_t__DOT__dut__DOT__fetch_imm_valid_latched = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18111367000742979380ull);
    vlSelf->core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14277635572328623097ull);
    for (int __Vi0 = 0; __Vi0 < 34; ++__Vi0) {
        vlSelf->core_t__DOT__dut__DOT__rf__DOT__regs[__Vi0] = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 2018063385297546167ull);
    }
    vlSelf->core_t__DOT__dut__DOT__rf__DOT____Vlvbound_hdb59fd83__0 = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 10676190073811778824ull);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->core_t__DOT__dut__DOT__dmem__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 310183055229742773ull);
    }
    vlSelf->core_t__DOT__dut__DOT__dmem__DOT__i = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7539620437739294374ull);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9526919608049418986ull);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
