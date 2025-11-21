// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VREGFILE_T__SYMS_H_
#define VERILATED_VREGFILE_T__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vregfile_t.h"

// INCLUDE MODULE CLASSES
#include "Vregfile_t___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vregfile_t__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vregfile_t* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vregfile_t___024root           TOP;

    // CONSTRUCTORS
    Vregfile_t__Syms(VerilatedContext* contextp, const char* namep, Vregfile_t* modelp);
    ~Vregfile_t__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
