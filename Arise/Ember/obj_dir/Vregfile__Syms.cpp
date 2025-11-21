// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vregfile__pch.h"
#include "Vregfile.h"
#include "Vregfile___024root.h"

// FUNCTIONS
Vregfile__Syms::~Vregfile__Syms()
{
}

Vregfile__Syms::Vregfile__Syms(VerilatedContext* contextp, const char* namep, Vregfile* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(35);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
