#include <iostream>

#include <verilated.h>
#ifdef TRACE
#include <verilated_vcd_c.h>
#endif

#define DEBUG

#define SIM_TIME 1000

#include <Vcore_t.h>
#ifndef TOP_MODULE
#define TOP_MODULE Vcore_t
#endif

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    TOP_MODULE* top = new TOP_MODULE;

#ifdef TRACE
    VerilatedVcdC* tfp = NULL;
    if (Verilated::commandArgsPlusMatch(argc, argv, "+trace")) {
        Verilated::traceEverOn(true);
        tfp = new VerilatedVcdC;
        top->trace(tfp, 99);
        top->open("wave.vcd");
    }
#endif

#ifdef DEBUG
    std::cout << "Simulation Started!\n";
#endif

    top->clk = 0;
    top->reset = 1;

    vluint64_t vl_time = 0;

    auto tick = [&](int cycles=1) {
        for (int c = 0; c < cycles; c++) {
            top->clk = 0;
            top->eval();
#ifdef TRACE
            if (tfp) tfp->dump(vl_time++);
#endif
            top->clk = 1;
            top->eval();
#ifdef TRACE
            if (tfp) tfp->dump(vl_time++);
#endif
        }
    };
    
    tick(2);
    top->reset = 0;

    for (int t=0; t<SIM_TIME; t++) {
        tick(1);
    }

    top->final();

#ifdef TRACE
    if (tfp) tfp->close();
#endif

#ifdef DEBUG
    std::cout << "Simulation Finished!\n";
#endif

    delete top;
    return 0;
}
