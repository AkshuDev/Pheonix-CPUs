// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vregfile_t__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vregfile_t::Vregfile_t(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vregfile_t__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vregfile_t::Vregfile_t(const char* _vcname__)
    : Vregfile_t(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vregfile_t::~Vregfile_t() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vregfile_t___024root___eval_debug_assertions(Vregfile_t___024root* vlSelf);
#endif  // VL_DEBUG
void Vregfile_t___024root___eval_static(Vregfile_t___024root* vlSelf);
void Vregfile_t___024root___eval_initial(Vregfile_t___024root* vlSelf);
void Vregfile_t___024root___eval_settle(Vregfile_t___024root* vlSelf);
void Vregfile_t___024root___eval(Vregfile_t___024root* vlSelf);

void Vregfile_t::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vregfile_t::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vregfile_t___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vregfile_t___024root___eval_static(&(vlSymsp->TOP));
        Vregfile_t___024root___eval_initial(&(vlSymsp->TOP));
        Vregfile_t___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vregfile_t___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vregfile_t::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vregfile_t::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vregfile_t::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vregfile_t___024root___eval_final(Vregfile_t___024root* vlSelf);

VL_ATTR_COLD void Vregfile_t::final() {
    Vregfile_t___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vregfile_t::hierName() const { return vlSymsp->name(); }
const char* Vregfile_t::modelName() const { return "Vregfile_t"; }
unsigned Vregfile_t::threads() const { return 1; }
void Vregfile_t::prepareClone() const { contextp()->prepareClone(); }
void Vregfile_t::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vregfile_t::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vregfile_t___024root__trace_decl_types(VerilatedVcd* tracep);

void Vregfile_t___024root__trace_init_top(Vregfile_t___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vregfile_t___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vregfile_t___024root*>(voidSelf);
    Vregfile_t__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vregfile_t___024root__trace_decl_types(tracep);
    Vregfile_t___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vregfile_t___024root__trace_register(Vregfile_t___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vregfile_t::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vregfile_t::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vregfile_t___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
