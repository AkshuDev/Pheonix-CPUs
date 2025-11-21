// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile_t.h for the primary calling header

#include "Vregfile_t__pch.h"
#include "Vregfile_t__Syms.h"
#include "Vregfile_t___024root.h"

void Vregfile_t___024root___ctor_var_reset(Vregfile_t___024root* vlSelf);

Vregfile_t___024root::Vregfile_t___024root(Vregfile_t__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vregfile_t___024root___ctor_var_reset(this);
}

void Vregfile_t___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vregfile_t___024root::~Vregfile_t___024root() {
}
