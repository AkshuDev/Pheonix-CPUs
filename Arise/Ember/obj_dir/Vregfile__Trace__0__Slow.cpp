// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vregfile__Syms.h"


VL_ATTR_COLD void Vregfile___024root__trace_init_sub__TOP__0(Vregfile___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_init_sub__TOP__0\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("regfile_test", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+49,0,"DATA_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+50,0,"REG_COUNT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+41,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+42,0,"reset",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"wr_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+44,0,"wr1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+45,0,"wr1_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+51,0,"rd1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+1,0,"rd1_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+52,0,"rd2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+53,0,"rd2_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+47,0,"temp_buf",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("regs", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declQuad(c+55+i*2,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, true,(i+0), 63,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+48,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->pushPrefix("uut", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+49,0,"DATA_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+119,0,"NUM_REGS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+120,0,"REG_ADDR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+41,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+42,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"wr_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+44,0,"wr1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+45,0,"wr1_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+51,0,"rd1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+1,0,"rd1_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+52,0,"rd2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declQuad(c+53,0,"rd2_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("regs", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 19; ++i) {
        tracep->declQuad(c+3+i*2,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 63,0);
    }
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vregfile___024root__trace_init_top(Vregfile___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_init_top\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vregfile___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vregfile___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vregfile___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vregfile___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vregfile___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vregfile___024root__trace_register(Vregfile___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_register\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vregfile___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vregfile___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vregfile___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vregfile___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vregfile___024root__trace_const_0_sub_0(Vregfile___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vregfile___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_const_0\n"); );
    // Init
    Vregfile___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vregfile___024root*>(voidSelf);
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vregfile___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vregfile___024root__trace_const_0_sub_0(Vregfile___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_const_0_sub_0\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+49,(0x40U),32);
    bufp->fullIData(oldp+50,(0x20U),32);
    bufp->fullCData(oldp+51,(vlSelfRef.regfile_test__DOT__rd1_addr),5);
    bufp->fullCData(oldp+52,(vlSelfRef.regfile_test__DOT__rd2_addr),5);
    bufp->fullQData(oldp+53,(vlSelfRef.regfile_test__DOT__rd2_out),64);
    bufp->fullQData(oldp+55,(vlSelfRef.regfile_test__DOT__regs[0]),64);
    bufp->fullQData(oldp+57,(vlSelfRef.regfile_test__DOT__regs[1]),64);
    bufp->fullQData(oldp+59,(vlSelfRef.regfile_test__DOT__regs[2]),64);
    bufp->fullQData(oldp+61,(vlSelfRef.regfile_test__DOT__regs[3]),64);
    bufp->fullQData(oldp+63,(vlSelfRef.regfile_test__DOT__regs[4]),64);
    bufp->fullQData(oldp+65,(vlSelfRef.regfile_test__DOT__regs[5]),64);
    bufp->fullQData(oldp+67,(vlSelfRef.regfile_test__DOT__regs[6]),64);
    bufp->fullQData(oldp+69,(vlSelfRef.regfile_test__DOT__regs[7]),64);
    bufp->fullQData(oldp+71,(vlSelfRef.regfile_test__DOT__regs[8]),64);
    bufp->fullQData(oldp+73,(vlSelfRef.regfile_test__DOT__regs[9]),64);
    bufp->fullQData(oldp+75,(vlSelfRef.regfile_test__DOT__regs[10]),64);
    bufp->fullQData(oldp+77,(vlSelfRef.regfile_test__DOT__regs[11]),64);
    bufp->fullQData(oldp+79,(vlSelfRef.regfile_test__DOT__regs[12]),64);
    bufp->fullQData(oldp+81,(vlSelfRef.regfile_test__DOT__regs[13]),64);
    bufp->fullQData(oldp+83,(vlSelfRef.regfile_test__DOT__regs[14]),64);
    bufp->fullQData(oldp+85,(vlSelfRef.regfile_test__DOT__regs[15]),64);
    bufp->fullQData(oldp+87,(vlSelfRef.regfile_test__DOT__regs[16]),64);
    bufp->fullQData(oldp+89,(vlSelfRef.regfile_test__DOT__regs[17]),64);
    bufp->fullQData(oldp+91,(vlSelfRef.regfile_test__DOT__regs[18]),64);
    bufp->fullQData(oldp+93,(vlSelfRef.regfile_test__DOT__regs[19]),64);
    bufp->fullQData(oldp+95,(vlSelfRef.regfile_test__DOT__regs[20]),64);
    bufp->fullQData(oldp+97,(vlSelfRef.regfile_test__DOT__regs[21]),64);
    bufp->fullQData(oldp+99,(vlSelfRef.regfile_test__DOT__regs[22]),64);
    bufp->fullQData(oldp+101,(vlSelfRef.regfile_test__DOT__regs[23]),64);
    bufp->fullQData(oldp+103,(vlSelfRef.regfile_test__DOT__regs[24]),64);
    bufp->fullQData(oldp+105,(vlSelfRef.regfile_test__DOT__regs[25]),64);
    bufp->fullQData(oldp+107,(vlSelfRef.regfile_test__DOT__regs[26]),64);
    bufp->fullQData(oldp+109,(vlSelfRef.regfile_test__DOT__regs[27]),64);
    bufp->fullQData(oldp+111,(vlSelfRef.regfile_test__DOT__regs[28]),64);
    bufp->fullQData(oldp+113,(vlSelfRef.regfile_test__DOT__regs[29]),64);
    bufp->fullQData(oldp+115,(vlSelfRef.regfile_test__DOT__regs[30]),64);
    bufp->fullQData(oldp+117,(vlSelfRef.regfile_test__DOT__regs[31]),64);
    bufp->fullIData(oldp+119,(0x13U),32);
    bufp->fullIData(oldp+120,(5U),32);
}

VL_ATTR_COLD void Vregfile___024root__trace_full_0_sub_0(Vregfile___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vregfile___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_full_0\n"); );
    // Init
    Vregfile___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vregfile___024root*>(voidSelf);
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vregfile___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vregfile___024root__trace_full_0_sub_0(Vregfile___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root__trace_full_0_sub_0\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullQData(oldp+1,((((0x13U > (IData)(vlSelfRef.regfile_test__DOT__rd1_addr)) 
                              & (0U != (IData)(vlSelfRef.regfile_test__DOT__rd1_addr)))
                              ? ((0x12U >= (IData)(vlSelfRef.regfile_test__DOT__rd1_addr))
                                  ? vlSelfRef.regfile_test__DOT__uut__DOT__regs
                                 [vlSelfRef.regfile_test__DOT__rd1_addr]
                                  : 0ULL) : 0ULL)),64);
    bufp->fullQData(oldp+3,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[0]),64);
    bufp->fullQData(oldp+5,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[1]),64);
    bufp->fullQData(oldp+7,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[2]),64);
    bufp->fullQData(oldp+9,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[3]),64);
    bufp->fullQData(oldp+11,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[4]),64);
    bufp->fullQData(oldp+13,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[5]),64);
    bufp->fullQData(oldp+15,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[6]),64);
    bufp->fullQData(oldp+17,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[7]),64);
    bufp->fullQData(oldp+19,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[8]),64);
    bufp->fullQData(oldp+21,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[9]),64);
    bufp->fullQData(oldp+23,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[10]),64);
    bufp->fullQData(oldp+25,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[11]),64);
    bufp->fullQData(oldp+27,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[12]),64);
    bufp->fullQData(oldp+29,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[13]),64);
    bufp->fullQData(oldp+31,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[14]),64);
    bufp->fullQData(oldp+33,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[15]),64);
    bufp->fullQData(oldp+35,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[16]),64);
    bufp->fullQData(oldp+37,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[17]),64);
    bufp->fullQData(oldp+39,(vlSelfRef.regfile_test__DOT__uut__DOT__regs[18]),64);
    bufp->fullBit(oldp+41,(vlSelfRef.regfile_test__DOT__clk));
    bufp->fullBit(oldp+42,(vlSelfRef.regfile_test__DOT__reset));
    bufp->fullBit(oldp+43,(vlSelfRef.regfile_test__DOT__wr_en));
    bufp->fullCData(oldp+44,(vlSelfRef.regfile_test__DOT__wr1_addr),5);
    bufp->fullQData(oldp+45,(vlSelfRef.regfile_test__DOT__wr1_data),64);
    bufp->fullIData(oldp+47,(vlSelfRef.regfile_test__DOT__temp_buf),32);
    bufp->fullIData(oldp+48,(vlSelfRef.regfile_test__DOT__i),32);
}
