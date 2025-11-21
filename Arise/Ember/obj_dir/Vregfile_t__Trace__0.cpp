// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vregfile_t__Syms.h"


void Vregfile_t___024root__trace_chg_0_sub_0(Vregfile_t___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vregfile_t___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root__trace_chg_0\n"); );
    // Init
    Vregfile_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vregfile_t___024root*>(voidSelf);
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vregfile_t___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vregfile_t___024root__trace_chg_0_sub_0(Vregfile_t___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root__trace_chg_0_sub_0\n"); );
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(((vlSelfRef.__Vm_traceActivity[1U] 
                      | vlSelfRef.__Vm_traceActivity
                      [2U])))) {
        bufp->chgBit(oldp+0,(vlSelfRef.regfile_test__DOT__wr_en));
        bufp->chgCData(oldp+1,(vlSelfRef.regfile_test__DOT__wr1_addr),5);
        bufp->chgQData(oldp+2,(vlSelfRef.regfile_test__DOT__wr1_data),64);
        bufp->chgIData(oldp+4,(vlSelfRef.regfile_test__DOT__temp_buf),32);
        bufp->chgIData(oldp+5,(vlSelfRef.regfile_test__DOT__i),32);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[3U]))) {
        bufp->chgQData(oldp+6,((((0x13U > (IData)(vlSelfRef.regfile_test__DOT__rd1_addr)) 
                                 & (0U != (IData)(vlSelfRef.regfile_test__DOT__rd1_addr)))
                                 ? ((0x12U >= (IData)(vlSelfRef.regfile_test__DOT__rd1_addr))
                                     ? vlSelfRef.regfile_test__DOT__uut__DOT__regs
                                    [vlSelfRef.regfile_test__DOT__rd1_addr]
                                     : 0ULL) : 0ULL)),64);
        bufp->chgQData(oldp+8,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[0]),64);
        bufp->chgQData(oldp+10,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[1]),64);
        bufp->chgQData(oldp+12,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[2]),64);
        bufp->chgQData(oldp+14,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[3]),64);
        bufp->chgQData(oldp+16,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[4]),64);
        bufp->chgQData(oldp+18,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[5]),64);
        bufp->chgQData(oldp+20,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[6]),64);
        bufp->chgQData(oldp+22,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[7]),64);
        bufp->chgQData(oldp+24,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[8]),64);
        bufp->chgQData(oldp+26,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[9]),64);
        bufp->chgQData(oldp+28,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[10]),64);
        bufp->chgQData(oldp+30,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[11]),64);
        bufp->chgQData(oldp+32,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[12]),64);
        bufp->chgQData(oldp+34,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[13]),64);
        bufp->chgQData(oldp+36,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[14]),64);
        bufp->chgQData(oldp+38,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[15]),64);
        bufp->chgQData(oldp+40,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[16]),64);
        bufp->chgQData(oldp+42,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[17]),64);
        bufp->chgQData(oldp+44,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[18]),64);
    }
    bufp->chgBit(oldp+46,(vlSelfRef.clk));
    bufp->chgBit(oldp+47,(vlSelfRef.reset));
}

void Vregfile_t___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile_t___024root__trace_cleanup\n"); );
    // Init
    Vregfile_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vregfile_t___024root*>(voidSelf);
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
