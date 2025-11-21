// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcore_t__Syms.h"


void Vcore_t___024root__trace_chg_0_sub_0(Vcore_t___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vcore_t___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root__trace_chg_0\n"); );
    // Init
    Vcore_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcore_t___024root*>(voidSelf);
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vcore_t___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vcore_t___024root__trace_chg_0_sub_0(Vcore_t___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root__trace_chg_0_sub_0\n"); );
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgIData(oldp+0,(vlSelfRef.core_t__DOT__dut__DOT__pc),32);
        bufp->chgIData(oldp+1,(vlSelfRef.core_t__DOT__dut__DOT__fetched_inst),32);
        bufp->chgBit(oldp+2,(vlSelfRef.core_t__DOT__dut__DOT__fetched_valid));
        bufp->chgQData(oldp+3,(vlSelfRef.core_t__DOT__dut__DOT__fetched_imm),64);
        bufp->chgBit(oldp+5,(vlSelfRef.core_t__DOT__dut__DOT__fetched_imm_valid));
        bufp->chgSData(oldp+6,(vlSelfRef.core_t__DOT__dut__DOT__opcode_out),12);
        bufp->chgCData(oldp+7,(vlSelfRef.core_t__DOT__dut__DOT__mode_out),4);
        bufp->chgCData(oldp+8,(vlSelfRef.core_t__DOT__dut__DOT__rsrc_out),6);
        bufp->chgCData(oldp+9,(vlSelfRef.core_t__DOT__dut__DOT__rdest_out),6);
        bufp->chgCData(oldp+10,(vlSelfRef.core_t__DOT__dut__DOT__flags_out),4);
        bufp->chgQData(oldp+11,(vlSelfRef.core_t__DOT__dut__DOT__imm_out),64);
        bufp->chgBit(oldp+13,(vlSelfRef.core_t__DOT__dut__DOT__imm_present));
        bufp->chgBit(oldp+14,(vlSelfRef.core_t__DOT__dut__DOT__alu_en));
        bufp->chgCData(oldp+15,(vlSelfRef.core_t__DOT__dut__DOT__alu_op),8);
        bufp->chgBit(oldp+16,(vlSelfRef.core_t__DOT__dut__DOT__mem_rd));
        bufp->chgBit(oldp+17,(vlSelfRef.core_t__DOT__dut__DOT__mem_wr));
        bufp->chgBit(oldp+18,(vlSelfRef.core_t__DOT__dut__DOT__reg_wr));
        bufp->chgBit(oldp+19,(vlSelfRef.core_t__DOT__dut__DOT__decoded_valid));
        bufp->chgQData(oldp+20,(vlSelfRef.core_t__DOT__dut__DOT__rsrc_data),64);
        bufp->chgBit(oldp+22,(vlSelfRef.core_t__DOT__dut__DOT__reg_we));
        bufp->chgCData(oldp+23,(vlSelfRef.core_t__DOT__dut__DOT__rwr_addr),6);
        bufp->chgQData(oldp+24,(vlSelfRef.core_t__DOT__dut__DOT__wr_data),64);
        bufp->chgCData(oldp+26,(vlSelfRef.core_t__DOT__dut__DOT__rsrc_addr),6);
        bufp->chgCData(oldp+27,(vlSelfRef.core_t__DOT__dut__DOT__rdest_addr),6);
        bufp->chgBit(oldp+28,(vlSelfRef.core_t__DOT__dut__DOT__alu_valid));
        bufp->chgQData(oldp+29,(vlSelfRef.core_t__DOT__dut__DOT__alu_a),64);
        bufp->chgQData(oldp+31,(vlSelfRef.core_t__DOT__dut__DOT__alu_b),64);
        bufp->chgQData(oldp+33,(vlSelfRef.core_t__DOT__dut__DOT__alu_res),64);
        bufp->chgBit(oldp+35,((0ULL == vlSelfRef.core_t__DOT__dut__DOT__alu_res)));
        bufp->chgBit(oldp+36,(vlSelfRef.core_t__DOT__dut__DOT__alu_carry));
        bufp->chgBit(oldp+37,(vlSelfRef.core_t__DOT__dut__DOT__alu_overflow));
        bufp->chgBit(oldp+38,(vlSelfRef.core_t__DOT__dut__DOT__alu_eq));
        bufp->chgBit(oldp+39,(vlSelfRef.core_t__DOT__dut__DOT__alu_lt));
        bufp->chgBit(oldp+40,(vlSelfRef.core_t__DOT__dut__DOT__alu_gt));
        bufp->chgQData(oldp+41,(vlSelfRef.core_t__DOT__dut__DOT__dm_rd_data),64);
        bufp->chgBit(oldp+43,(vlSelfRef.core_t__DOT__dut__DOT__dm_rd_en));
        bufp->chgBit(oldp+44,(vlSelfRef.core_t__DOT__dut__DOT__dm_wr_en));
        bufp->chgIData(oldp+45,(vlSelfRef.core_t__DOT__dut__DOT__dm_addr),32);
        bufp->chgQData(oldp+46,(vlSelfRef.core_t__DOT__dut__DOT__dm_wr_data),64);
        bufp->chgCData(oldp+48,(vlSelfRef.core_t__DOT__dut__DOT__state),2);
        bufp->chgSData(oldp+49,(vlSelfRef.core_t__DOT__dut__DOT__cur_opcode),12);
        bufp->chgCData(oldp+50,(vlSelfRef.core_t__DOT__dut__DOT__cur_mode),4);
        bufp->chgCData(oldp+51,(vlSelfRef.core_t__DOT__dut__DOT__cur_rsrc),6);
        bufp->chgCData(oldp+52,(vlSelfRef.core_t__DOT__dut__DOT__cur_rdest),6);
        bufp->chgCData(oldp+53,(vlSelfRef.core_t__DOT__dut__DOT__cur_flags),4);
        bufp->chgQData(oldp+54,(vlSelfRef.core_t__DOT__dut__DOT__cur_imm),64);
        bufp->chgBit(oldp+56,(vlSelfRef.core_t__DOT__dut__DOT__cur_imm_present));
        bufp->chgBit(oldp+57,(vlSelfRef.core_t__DOT__dut__DOT__pending_imm_expected));
        bufp->chgIData(oldp+58,(vlSelfRef.core_t__DOT__dut__DOT__fetch_inst_latched),32);
        bufp->chgQData(oldp+59,(vlSelfRef.core_t__DOT__dut__DOT__fetch_imm_latched),64);
        bufp->chgBit(oldp+61,(vlSelfRef.core_t__DOT__dut__DOT__dec__DOT__waiting_for_imm));
        bufp->chgIData(oldp+62,(vlSelfRef.core_t__DOT__dut__DOT__dmem__DOT__i),32);
    }
    bufp->chgBit(oldp+63,(vlSelfRef.clk));
    bufp->chgBit(oldp+64,(vlSelfRef.reset));
    bufp->chgIData(oldp+65,(vlSelfRef.core_t__DOT__load_program__Vstatic__i),32);
    bufp->chgIData(oldp+66,(vlSelfRef.core_t__DOT__dut__DOT__i),32);
}

void Vcore_t___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_t___024root__trace_cleanup\n"); );
    // Init
    Vcore_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcore_t___024root*>(voidSelf);
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
