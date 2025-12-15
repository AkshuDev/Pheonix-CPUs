// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcore_t__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vcore_t::Vcore_t(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcore_t__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vcore_t::Vcore_t(const char* _vcname__)
    : Vcore_t(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcore_t::~Vcore_t() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcore_t___024root___eval_debug_assertions(Vcore_t___024root* vlSelf);
#endif  // VL_DEBUG
void Vcore_t___024root___eval_static(Vcore_t___024root* vlSelf);
void Vcore_t___024root___eval_initial(Vcore_t___024root* vlSelf);
void Vcore_t___024root___eval_settle(Vcore_t___024root* vlSelf);
void Vcore_t___024root___eval(Vcore_t___024root* vlSelf);

void Vcore_t::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcore_t::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcore_t___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcore_t___024root___eval_static(&(vlSymsp->TOP));
        Vcore_t___024root___eval_initial(&(vlSymsp->TOP));
        Vcore_t___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcore_t___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcore_t::eventsPending() { return false; }

uint64_t Vcore_t::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vcore_t::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcore_t___024root___eval_final(Vcore_t___024root* vlSelf);

VL_ATTR_COLD void Vcore_t::final() {
    Vcore_t___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcore_t::hierName() const { return vlSymsp->name(); }
const char* Vcore_t::modelName() const { return "Vcore_t"; }
unsigned Vcore_t::threads() const { return 1; }
void Vcore_t::prepareClone() const { contextp()->prepareClone(); }
void Vcore_t::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vcore_t::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vcore_t___024root__trace_decl_types(VerilatedVcd* tracep);

void Vcore_t___024root__trace_init_top(Vcore_t___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vcore_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcore_t___024root*>(voidSelf);
    Vcore_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vcore_t___024root__trace_decl_types(tracep);
    Vcore_t___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vcore_t___024root__trace_register(Vcore_t___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vcore_t::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vcore_t::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vcore_t___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
