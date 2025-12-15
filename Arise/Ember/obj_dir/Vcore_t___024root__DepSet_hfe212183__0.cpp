// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_t.h for the primary calling header

#include "Vcore_t__pch.h"
#include "Vcore_t___024root.h"

void Vcore_t___024root___eval_act(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_act\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vcore_t___024root___nba_sequent__TOP__0(Vcore_t___024root* vlSelf);

void Vcore_t___024root___eval_nba(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_nba\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vcore_t___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
}

VL_INLINE_OPT void Vcore_t___024root___nba_sequent__TOP__0(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___nba_sequent__TOP__0\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __Vdly__core_t__DOT__dut__DOT__pc;
    __Vdly__core_t__DOT__dut__DOT__pc = 0;
    CData/*1:0*/ __Vdly__core_t__DOT__dut__DOT__state;
    __Vdly__core_t__DOT__dut__DOT__state = 0;
    SData/*11:0*/ __Vdly__core_t__DOT__dut__DOT__cur_opcode;
    __Vdly__core_t__DOT__dut__DOT__cur_opcode = 0;
    CData/*5:0*/ __Vdly__core_t__DOT__dut__DOT__cur_rsrc;
    __Vdly__core_t__DOT__dut__DOT__cur_rsrc = 0;
    CData/*5:0*/ __Vdly__core_t__DOT__dut__DOT__cur_rdest;
    __Vdly__core_t__DOT__dut__DOT__cur_rdest = 0;
    QData/*63:0*/ __Vdly__core_t__DOT__dut__DOT__cur_imm;
    __Vdly__core_t__DOT__dut__DOT__cur_imm = 0;
    CData/*0:0*/ __Vdly__core_t__DOT__dut__DOT__cur_imm_present;
    __Vdly__core_t__DOT__dut__DOT__cur_imm_present = 0;
    QData/*63:0*/ __Vdly__core_t__DOT__dut__DOT__wr_data;
    __Vdly__core_t__DOT__dut__DOT__wr_data = 0;
    CData/*5:0*/ __Vdly__core_t__DOT__dut__DOT__rwr_addr;
    __Vdly__core_t__DOT__dut__DOT__rwr_addr = 0;
    QData/*63:0*/ __Vdly__core_t__DOT__dut__DOT__alu_res;
    __Vdly__core_t__DOT__dut__DOT__alu_res = 0;
    QData/*63:0*/ __Vdly__core_t__DOT__dut__DOT__dm_rd_data;
    __Vdly__core_t__DOT__dut__DOT__dm_rd_data = 0;
    QData/*63:0*/ __VdlyVal__core_t__DOT__dut__DOT__rf__DOT__regs__v0;
    __VdlyVal__core_t__DOT__dut__DOT__rf__DOT__regs__v0 = 0;
    CData/*5:0*/ __VdlyDim0__core_t__DOT__dut__DOT__rf__DOT__regs__v0;
    __VdlyDim0__core_t__DOT__dut__DOT__rf__DOT__regs__v0 = 0;
    CData/*0:0*/ __VdlySet__core_t__DOT__dut__DOT__rf__DOT__regs__v0;
    __VdlySet__core_t__DOT__dut__DOT__rf__DOT__regs__v0 = 0;
    QData/*63:0*/ __VdlyVal__core_t__DOT__dut__DOT__dmem__DOT__mem__v0;
    __VdlyVal__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 = 0;
    CData/*7:0*/ __VdlyDim0__core_t__DOT__dut__DOT__dmem__DOT__mem__v0;
    __VdlyDim0__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 = 0;
    CData/*0:0*/ __VdlySet__core_t__DOT__dut__DOT__dmem__DOT__mem__v0;
    __VdlySet__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 = 0;
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_3;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_7;
    VlWide<3>/*95:0*/ __Vtemp_8;
    VlWide<3>/*95:0*/ __Vtemp_9;
    // Body
    __Vdly__core_t__DOT__dut__DOT__pc = vlSelfRef.core_t__DOT__dut__DOT__pc;
    __Vdly__core_t__DOT__dut__DOT__state = vlSelfRef.core_t__DOT__dut__DOT__state;
    __Vdly__core_t__DOT__dut__DOT__cur_opcode = vlSelfRef.core_t__DOT__dut__DOT__cur_opcode;
    __Vdly__core_t__DOT__dut__DOT__cur_rsrc = vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc;
    __Vdly__core_t__DOT__dut__DOT__cur_rdest = vlSelfRef.core_t__DOT__dut__DOT__cur_rdest;
    __Vdly__core_t__DOT__dut__DOT__cur_imm = vlSelfRef.core_t__DOT__dut__DOT__cur_imm;
    __Vdly__core_t__DOT__dut__DOT__cur_imm_present 
        = vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present;
    __Vdly__core_t__DOT__dut__DOT__wr_data = vlSelfRef.core_t__DOT__dut__DOT__wr_data;
    __Vdly__core_t__DOT__dut__DOT__rwr_addr = vlSelfRef.core_t__DOT__dut__DOT__rwr_addr;
    __VdlySet__core_t__DOT__dut__DOT__rf__DOT__regs__v0 = 0U;
    __Vdly__core_t__DOT__dut__DOT__dm_rd_data = vlSelfRef.core_t__DOT__dut__DOT__dm_rd_data;
    __VdlySet__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 = 0U;
    __Vdly__core_t__DOT__dut__DOT__alu_res = vlSelfRef.core_t__DOT__dut__DOT__alu_res;
    if (((IData)(vlSelfRef.core_t__DOT__dut__DOT__reg_we) 
         & (0U != (IData)(vlSelfRef.core_t__DOT__dut__DOT__rwr_addr)))) {
        if ((0x22U > (IData)(vlSelfRef.core_t__DOT__dut__DOT__rwr_addr))) {
            vlSelfRef.core_t__DOT__dut__DOT__rf__DOT____Vlvbound_hdb59fd83__0 
                = vlSelfRef.core_t__DOT__dut__DOT__wr_data;
            if ((0x21U >= (IData)(vlSelfRef.core_t__DOT__dut__DOT__rwr_addr))) {
                __VdlyVal__core_t__DOT__dut__DOT__rf__DOT__regs__v0 
                    = vlSelfRef.core_t__DOT__dut__DOT__rf__DOT____Vlvbound_hdb59fd83__0;
                __VdlyDim0__core_t__DOT__dut__DOT__rf__DOT__regs__v0 
                    = vlSelfRef.core_t__DOT__dut__DOT__rwr_addr;
                __VdlySet__core_t__DOT__dut__DOT__rf__DOT__regs__v0 = 1U;
            }
        }
    }
    if (vlSelfRef.core_t__DOT__dut__DOT__dm_rd_en) {
        __Vdly__core_t__DOT__dut__DOT__dm_rd_data = 
            vlSelfRef.core_t__DOT__dut__DOT__dmem__DOT__mem
            [(0xffU & vlSelfRef.core_t__DOT__dut__DOT__dm_addr)];
    }
    if (vlSelfRef.core_t__DOT__dut__DOT__dm_wr_en) {
        __VdlyVal__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 
            = vlSelfRef.core_t__DOT__dut__DOT__dm_wr_data;
        __VdlyDim0__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 
            = (0xffU & vlSelfRef.core_t__DOT__dut__DOT__dm_addr);
        __VdlySet__core_t__DOT__dut__DOT__dmem__DOT__mem__v0 = 1U;
    }
    vlSelfRef.core_t__DOT__dut__DOT__alu_gt = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__alu_lt = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__alu_eq = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__alu_carry = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__alu_overflow = 0U;
    if (vlSelfRef.core_t__DOT__dut__DOT__alu_valid) {
        __Vdly__core_t__DOT__dut__DOT__alu_res = ((0x80U 
                                                   & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                   ? 0ULL
                                                   : 
                                                  ((0x40U 
                                                    & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                    ? 0ULL
                                                    : 
                                                   ((0x20U 
                                                     & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                     ? 0ULL
                                                     : 
                                                    ((0x10U 
                                                      & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                      ? 
                                                     ((8U 
                                                       & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                       ? 0ULL
                                                       : 
                                                      ((4U 
                                                        & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                        ? 0ULL
                                                        : 
                                                       ((2U 
                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                         ? 0ULL
                                                         : 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (~ 
                                                          (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                           ^ vlSelfRef.core_t__DOT__dut__DOT__alu_b))
                                                          : 
                                                         (~ 
                                                          (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                           | vlSelfRef.core_t__DOT__dut__DOT__alu_b))))))
                                                      : 
                                                     ((8U 
                                                       & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                       ? 
                                                      ((4U 
                                                        & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                        ? 
                                                       ((2U 
                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                         ? 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (~ 
                                                          (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                           & vlSelfRef.core_t__DOT__dut__DOT__alu_b))
                                                          : 0ULL)
                                                         : 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                           << 1U) 
                                                          | (QData)((IData)(
                                                                            (1U 
                                                                             & (IData)(
                                                                                (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                                                >> 0x3fU))))))
                                                          : 
                                                         VL_SHIFTRS_QQI(64,64,6, vlSelfRef.core_t__DOT__dut__DOT__alu_a, 
                                                                        (0x3fU 
                                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_b)))))
                                                        : 
                                                       ((2U 
                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                         ? 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          >> 
                                                          (0x3fU 
                                                           & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_b)))
                                                          : 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          << 
                                                          (0x3fU 
                                                           & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_b))))
                                                         : 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (~ vlSelfRef.core_t__DOT__dut__DOT__alu_a)
                                                          : 0ULL)))
                                                       : 
                                                      ((4U 
                                                        & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                        ? 
                                                       ((2U 
                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                         ? 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          ^ vlSelfRef.core_t__DOT__dut__DOT__alu_b)
                                                          : 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          | vlSelfRef.core_t__DOT__dut__DOT__alu_b))
                                                         : 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          & vlSelfRef.core_t__DOT__dut__DOT__alu_b)
                                                          : 
                                                         VL_DIV_QQQ(64, vlSelfRef.core_t__DOT__dut__DOT__alu_a, vlSelfRef.core_t__DOT__dut__DOT__alu_b)))
                                                        : 
                                                       ((2U 
                                                         & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                         ? 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          * vlSelfRef.core_t__DOT__dut__DOT__alu_b)
                                                          : 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          - vlSelfRef.core_t__DOT__dut__DOT__alu_b))
                                                         : 
                                                        ((1U 
                                                          & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))
                                                          ? 
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          + vlSelfRef.core_t__DOT__dut__DOT__alu_b)
                                                          : 0ULL))))))));
        if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                      >> 7U)))) {
            if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                          >> 6U)))) {
                if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                              >> 5U)))) {
                    if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                                  >> 4U)))) {
                        if ((8U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))) {
                            if ((4U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))) {
                                if ((2U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))) {
                                    if ((1U & (~ (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op)))) {
                                        if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                             != vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                            if (VL_GTS_IQQ(64, vlSelfRef.core_t__DOT__dut__DOT__alu_a, vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                                vlSelfRef.core_t__DOT__dut__DOT__alu_gt = 1U;
                                            }
                                            if (VL_LTES_IQQ(64, vlSelfRef.core_t__DOT__dut__DOT__alu_a, vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                                vlSelfRef.core_t__DOT__dut__DOT__alu_lt = 1U;
                                            }
                                        }
                                        if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                             == vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                            vlSelfRef.core_t__DOT__dut__DOT__alu_eq = 1U;
                                        }
                                    }
                                }
                            } else if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                                                 >> 1U)))) {
                                if ((1U & (~ (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op)))) {
                                    if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                         != vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                        if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                             > vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                            vlSelfRef.core_t__DOT__dut__DOT__alu_gt = 1U;
                                        }
                                        if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                             <= vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                            vlSelfRef.core_t__DOT__dut__DOT__alu_lt = 1U;
                                        }
                                    }
                                    if ((vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                         == vlSelfRef.core_t__DOT__dut__DOT__alu_b)) {
                                        vlSelfRef.core_t__DOT__dut__DOT__alu_eq = 1U;
                                    }
                                }
                            }
                        }
                        if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                                      >> 3U)))) {
                            if ((1U & (~ ((IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op) 
                                          >> 2U)))) {
                                if ((2U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))) {
                                    if ((1U & (~ (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op)))) {
                                        __Vtemp_2[0U] 
                                            = (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_a);
                                        __Vtemp_2[1U] 
                                            = (IData)(
                                                      (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                       >> 0x20U));
                                        __Vtemp_2[2U] = 0U;
                                        __Vtemp_3[0U] 
                                            = (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_b);
                                        __Vtemp_3[1U] 
                                            = (IData)(
                                                      (vlSelfRef.core_t__DOT__dut__DOT__alu_b 
                                                       >> 0x20U));
                                        __Vtemp_3[2U] = 0U;
                                        VL_SUB_W(3, __Vtemp_4, __Vtemp_2, __Vtemp_3);
                                        vlSelfRef.core_t__DOT__dut__DOT__alu_carry 
                                            = (1U & 
                                               __Vtemp_4[2U]);
                                        vlSelfRef.core_t__DOT__dut__DOT__alu_overflow 
                                            = (1U & 
                                               (((IData)(
                                                         (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                          >> 0x3fU)) 
                                                 ^ (IData)(
                                                           (vlSelfRef.core_t__DOT__dut__DOT__alu_b 
                                                            >> 0x3fU))) 
                                                & ((IData)(
                                                           (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                            >> 0x3fU)) 
                                                   ^ (IData)(
                                                             (vlSelfRef.core_t__DOT__dut__DOT__alu_res 
                                                              >> 0x3fU)))));
                                    }
                                } else if ((1U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_op))) {
                                    __Vtemp_7[0U] = (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_a);
                                    __Vtemp_7[1U] = (IData)(
                                                            (vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                                                             >> 0x20U));
                                    __Vtemp_7[2U] = 0U;
                                    __Vtemp_8[0U] = (IData)(vlSelfRef.core_t__DOT__dut__DOT__alu_b);
                                    __Vtemp_8[1U] = (IData)(
                                                            (vlSelfRef.core_t__DOT__dut__DOT__alu_b 
                                                             >> 0x20U));
                                    __Vtemp_8[2U] = 0U;
                                    VL_ADD_W(3, __Vtemp_9, __Vtemp_7, __Vtemp_8);
                                    vlSelfRef.core_t__DOT__dut__DOT__alu_carry 
                                        = (1U & __Vtemp_9[2U]);
                                }
                            }
                        }
                    }
                }
            }
        }
    } else {
        __Vdly__core_t__DOT__dut__DOT__alu_res = 0ULL;
    }
    if (__VdlySet__core_t__DOT__dut__DOT__rf__DOT__regs__v0) {
        vlSelfRef.core_t__DOT__dut__DOT__rf__DOT__regs[__VdlyDim0__core_t__DOT__dut__DOT__rf__DOT__regs__v0] 
            = __VdlyVal__core_t__DOT__dut__DOT__rf__DOT__regs__v0;
    }
    if (__VdlySet__core_t__DOT__dut__DOT__dmem__DOT__mem__v0) {
        vlSelfRef.core_t__DOT__dut__DOT__dmem__DOT__mem[__VdlyDim0__core_t__DOT__dut__DOT__dmem__DOT__mem__v0] 
            = __VdlyVal__core_t__DOT__dut__DOT__dmem__DOT__mem__v0;
    }
    vlSelfRef.core_t__DOT__dut__DOT__reg_we = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__dm_rd_en = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__dm_wr_en = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__alu_valid = 0U;
    if ((0U == (IData)(vlSelfRef.core_t__DOT__dut__DOT__state))) {
        if (VL_UNLIKELY((vlSelfRef.core_t__DOT__dut__DOT__decoded_valid))) {
            VL_WRITEF_NX("Fetch Cycle Complete -\n\tOpcode: %x\n\tMode: %b\n\tRegisters: %2# (src), %2# (dest)\n\tImm: %x\n\tFlags: %b\n\tImm Present: %b\n\n",0,
                         12,vlSelfRef.core_t__DOT__dut__DOT__cur_opcode,
                         4,(IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_mode),
                         6,vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc,
                         6,(IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_rdest),
                         64,vlSelfRef.core_t__DOT__dut__DOT__cur_imm,
                         4,(IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_flags),
                         1,vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present);
            __Vdly__core_t__DOT__dut__DOT__state = 2U;
            __Vdly__core_t__DOT__dut__DOT__cur_opcode 
                = vlSelfRef.core_t__DOT__dut__DOT__opcode_out;
            vlSelfRef.core_t__DOT__dut__DOT__cur_mode 
                = vlSelfRef.core_t__DOT__dut__DOT__mode_out;
            __Vdly__core_t__DOT__dut__DOT__cur_rsrc 
                = vlSelfRef.core_t__DOT__dut__DOT__rsrc_out;
            __Vdly__core_t__DOT__dut__DOT__cur_rdest 
                = vlSelfRef.core_t__DOT__dut__DOT__rdest_out;
            vlSelfRef.core_t__DOT__dut__DOT__cur_flags 
                = vlSelfRef.core_t__DOT__dut__DOT__flags_out;
            __Vdly__core_t__DOT__dut__DOT__cur_imm 
                = vlSelfRef.core_t__DOT__dut__DOT__imm_out;
            __Vdly__core_t__DOT__dut__DOT__cur_imm_present 
                = vlSelfRef.core_t__DOT__dut__DOT__imm_present;
        }
    } else if ((2U == (IData)(vlSelfRef.core_t__DOT__dut__DOT__state))) {
        vlSelfRef.core_t__DOT__dut__DOT__reg_we = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__alu_valid = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__dm_rd_en = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__dm_wr_en = 0U;
        if ((0x100U > (IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_opcode))) {
            vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr 
                = vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc;
            vlSelfRef.core_t__DOT__dut__DOT__rdest_addr 
                = vlSelfRef.core_t__DOT__dut__DOT__cur_rdest;
            vlSelfRef.core_t__DOT__dut__DOT__alu_a 
                = vlSelfRef.core_t__DOT__dut__DOT__rsrc_data;
            vlSelfRef.core_t__DOT__dut__DOT__alu_b 
                = vlSelfRef.core_t__DOT__dut__DOT__rdest_data;
            vlSelfRef.core_t__DOT__dut__DOT__alu_valid = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__reg_we = 1U;
            __Vdly__core_t__DOT__dut__DOT__wr_data 
                = vlSelfRef.core_t__DOT__dut__DOT__alu_res;
            __Vdly__core_t__DOT__dut__DOT__state = 0U;
            __Vdly__core_t__DOT__dut__DOT__rwr_addr 
                = vlSelfRef.core_t__DOT__dut__DOT__cur_rdest;
        } else if (VL_UNLIKELY(((0x100U == (IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_opcode))))) {
            VL_WRITEF_NX("Exec Done!\n\tWr Addr: %x\n\tWr Data: %x\n\n",0,
                         6,vlSelfRef.core_t__DOT__dut__DOT__rwr_addr,
                         64,vlSelfRef.core_t__DOT__dut__DOT__wr_data);
            vlSelfRef.core_t__DOT__dut__DOT__dm_addr 
                = ((IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present)
                    ? (IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_imm)
                    : 0x1000U);
            vlSelfRef.core_t__DOT__dut__DOT__dm_rd_en = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__reg_we = 1U;
            __Vdly__core_t__DOT__dut__DOT__state = 0U;
            __Vdly__core_t__DOT__dut__DOT__rwr_addr 
                = vlSelfRef.core_t__DOT__dut__DOT__cur_rdest;
            __Vdly__core_t__DOT__dut__DOT__wr_data 
                = vlSelfRef.core_t__DOT__dut__DOT__dm_rd_data;
        } else if ((0x101U == (IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_opcode))) {
            vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr 
                = vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc;
            vlSelfRef.core_t__DOT__dut__DOT__dm_addr 
                = ((IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present)
                    ? (IData)(vlSelfRef.core_t__DOT__dut__DOT__cur_imm)
                    : 0x1000U);
            vlSelfRef.core_t__DOT__dut__DOT__dm_wr_en = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__dm_wr_data 
                = vlSelfRef.core_t__DOT__dut__DOT__rsrc_data;
            __Vdly__core_t__DOT__dut__DOT__state = 0U;
        } else {
            __Vdly__core_t__DOT__dut__DOT__state = 0U;
        }
    } else {
        __Vdly__core_t__DOT__dut__DOT__state = 0U;
    }
    vlSelfRef.core_t__DOT__dut__DOT__dm_rd_data = __Vdly__core_t__DOT__dut__DOT__dm_rd_data;
    vlSelfRef.core_t__DOT__dut__DOT__state = __Vdly__core_t__DOT__dut__DOT__state;
    vlSelfRef.core_t__DOT__dut__DOT__cur_opcode = __Vdly__core_t__DOT__dut__DOT__cur_opcode;
    vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc = __Vdly__core_t__DOT__dut__DOT__cur_rsrc;
    vlSelfRef.core_t__DOT__dut__DOT__cur_rdest = __Vdly__core_t__DOT__dut__DOT__cur_rdest;
    vlSelfRef.core_t__DOT__dut__DOT__cur_imm = __Vdly__core_t__DOT__dut__DOT__cur_imm;
    vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present 
        = __Vdly__core_t__DOT__dut__DOT__cur_imm_present;
    vlSelfRef.core_t__DOT__dut__DOT__alu_res = __Vdly__core_t__DOT__dut__DOT__alu_res;
    vlSelfRef.core_t__DOT__dut__DOT__rwr_addr = __Vdly__core_t__DOT__dut__DOT__rwr_addr;
    vlSelfRef.core_t__DOT__dut__DOT__wr_data = __Vdly__core_t__DOT__dut__DOT__wr_data;
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
    vlSelfRef.core_t__DOT__dut__DOT__decoded_valid = 0U;
    if (vlSelfRef.core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm) {
        if (vlSelfRef.core_t__DOT__dut__DOT__fetched_imm_valid) {
            vlSelfRef.core_t__DOT__dut__DOT__imm_out 
                = vlSelfRef.core_t__DOT__dut__DOT__fetched_imm;
            vlSelfRef.core_t__DOT__dut__DOT__imm_present = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm = 0U;
            vlSelfRef.core_t__DOT__dut__DOT__decoded_valid = 1U;
        }
    } else {
        vlSelfRef.core_t__DOT__dut__DOT__opcode_out 
            = (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
               >> 0x14U);
        vlSelfRef.core_t__DOT__dut__DOT__mode_out = 
            (0xfU & (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                     >> 0x10U));
        vlSelfRef.core_t__DOT__dut__DOT__rsrc_out = 
            (0x3fU & (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                      >> 0xaU));
        vlSelfRef.core_t__DOT__dut__DOT__rdest_out 
            = (0x3fU & (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                        >> 4U));
        vlSelfRef.core_t__DOT__dut__DOT__imm_present = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__mem_rd = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__mem_wr = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__reg_wr = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__alu_en = 0U;
        if ((0x100U > (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                       >> 0x14U))) {
            vlSelfRef.core_t__DOT__dut__DOT__alu_en = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__reg_wr = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__decoded_valid = 1U;
            vlSelfRef.core_t__DOT__dut__DOT__alu_op 
                = (0xffU & (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                            >> 0x14U));
        } else {
            if ((0x100U == (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                            >> 0x14U))) {
                vlSelfRef.core_t__DOT__dut__DOT__mem_rd = 1U;
                vlSelfRef.core_t__DOT__dut__DOT__reg_wr = 1U;
            } else if ((0x101U == (vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
                                   >> 0x14U))) {
                vlSelfRef.core_t__DOT__dut__DOT__mem_wr = 1U;
            }
            if ((1U & (IData)(vlSelfRef.core_t__DOT__dut__DOT__flags_out))) {
                vlSelfRef.core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm = 1U;
            } else {
                vlSelfRef.core_t__DOT__dut__DOT__decoded_valid = 1U;
            }
        }
        vlSelfRef.core_t__DOT__dut__DOT__flags_out 
            = (0xfU & vlSelfRef.core_t__DOT__dut__DOT__fetched_inst);
    }
    vlSelfRef.core_t__DOT__dut__DOT__fetched_valid = 0U;
    vlSelfRef.core_t__DOT__dut__DOT__fetched_imm_valid = 0U;
    if (vlSelfRef.core_t__DOT__dut__DOT__pending_imm_expected) {
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffffffffffff00ULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | (IData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                 [(0x3ffU & vlSelfRef.core_t__DOT__dut__DOT__pc)])));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffffffffff00ffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(1U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 8U));
        vlSelfRef.core_t__DOT__dut__DOT__fetched_imm_valid = 1U;
        vlSelfRef.core_t__DOT__dut__DOT__pending_imm_expected = 0U;
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffffffff00ffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(2U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x10U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffffff00ffffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(3U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x18U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffff00ffffffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(4U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x20U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffff00ffffffffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(5U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x28U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xff00ffffffffffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(6U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x30U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched 
            = ((0xffffffffffffffULL & vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched) 
               | ((QData)((IData)(vlSelfRef.core_t__DOT__dut__DOT__imem
                                  [(0x3ffU & ((IData)(7U) 
                                              + vlSelfRef.core_t__DOT__dut__DOT__pc))])) 
                  << 0x38U));
        vlSelfRef.core_t__DOT__dut__DOT__fetched_imm 
            = vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched;
        __Vdly__core_t__DOT__dut__DOT__pc = ((IData)(8U) 
                                             + vlSelfRef.core_t__DOT__dut__DOT__pc);
    } else {
        vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched 
            = ((0xffffff00U & vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched) 
               | vlSelfRef.core_t__DOT__dut__DOT__imem
               [(0x3ffU & vlSelfRef.core_t__DOT__dut__DOT__pc)]);
        vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched 
            = ((0xffff00ffU & vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched) 
               | (vlSelfRef.core_t__DOT__dut__DOT__imem
                  [(0x3ffU & ((IData)(1U) + vlSelfRef.core_t__DOT__dut__DOT__pc))] 
                  << 8U));
        vlSelfRef.core_t__DOT__dut__DOT__fetched_valid = 1U;
        vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched 
            = ((0xff00ffffU & vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched) 
               | (vlSelfRef.core_t__DOT__dut__DOT__imem
                  [(0x3ffU & ((IData)(2U) + vlSelfRef.core_t__DOT__dut__DOT__pc))] 
                  << 0x10U));
        vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched 
            = ((0xffffffU & vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched) 
               | (vlSelfRef.core_t__DOT__dut__DOT__imem
                  [(0x3ffU & ((IData)(3U) + vlSelfRef.core_t__DOT__dut__DOT__pc))] 
                  << 0x18U));
        vlSelfRef.core_t__DOT__dut__DOT__fetched_inst 
            = vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched;
        if ((8U & vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched)) {
            __Vdly__core_t__DOT__dut__DOT__pc = ((IData)(4U) 
                                                 + vlSelfRef.core_t__DOT__dut__DOT__pc);
            vlSelfRef.core_t__DOT__dut__DOT__pending_imm_expected = 1U;
        } else {
            __Vdly__core_t__DOT__dut__DOT__pc = ((IData)(4U) 
                                                 + vlSelfRef.core_t__DOT__dut__DOT__pc);
        }
    }
    vlSelfRef.core_t__DOT__dut__DOT__pc = __Vdly__core_t__DOT__dut__DOT__pc;
}

void Vcore_t___024root___eval_triggers__act(Vcore_t___024root* vlSelf);

bool Vcore_t___024root___eval_phase__act(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_phase__act\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vcore_t___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vcore_t___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vcore_t___024root___eval_phase__nba(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_phase__nba\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vcore_t___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__nba(Vcore_t___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcore_t___024root___dump_triggers__act(Vcore_t___024root* vlSelf);
#endif  // VL_DEBUG

void Vcore_t___024root___eval(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
            Vcore_t___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("core_t.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vcore_t___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("core_t.v", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vcore_t___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vcore_t___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vcore_t___024root___eval_debug_assertions(Vcore_t___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root___eval_debug_assertions\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY(((vlSelfRef.reset & 0xfeU)))) {
        Verilated::overWidthError("reset");}
}
#endif  // VL_DEBUG
