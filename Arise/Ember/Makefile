SRCS := cpu_t.v \
		cpu.v \
		supercore.v \
		cache_directory.v core.v \
		mem_arbiter.v alu.v cache_controller.v thread.v \
		regfile.v decoder.v istate.v mem.v

IVERILOG := iverilog
VERILOG_FLAGS := -g 2012
OUTPUT := obj/cpu_t

.PHONY: all clean show_yosys

all: $(OUTPUT)

$(OUTPUT): $(SRCS)
	@echo "Building..."
	$(IVERILOG) $(VERILOG_FLAGS) -o $(OUTPUT) $(SRCS)
	@echo "Done!"

clean:
	@echo "Cleaning..."
	rm -rf $(OUTPUT)
	@echo "Done!"

show_yosys:
	@echo "Running YOSYS Synthesis"
	@mkdir -p yosys

	yosys scripts/script_show.ys
	dot -Tpdf yosys/cpu.dot -o yosys/cpu.pdf

	@echo "Done!"