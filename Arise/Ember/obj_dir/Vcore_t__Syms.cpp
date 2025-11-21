// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vcore_t__pch.h"
#include "Vcore_t.h"
#include "Vcore_t___024root.h"

// FUNCTIONS
Vcore_t__Syms::~Vcore_t__Syms()
{
}

Vcore_t__Syms::Vcore_t__Syms(VerilatedContext* contextp, const char* namep, Vcore_t* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(276);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
