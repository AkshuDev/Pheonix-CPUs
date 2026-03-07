SRCS := cpu_t.v \
		cpu.v \
		supercore.v \
		core.v \
		alu.v thread.v \
		regfile.v decoder.v istate.v mem.v

IVERILOG := iverilog
VERILOG_FLAGS := -g 2012
OUTPUT := obj/cpu_t

.PHONY: all clean

all: $(OUTPUT)

$(OUTPUT): $(SRCS)
	@echo "Building..."
	$(IVERILOG) $(VERILOG_FLAGS) -o $(OUTPUT) $(SRCS)
	@echo "Done!"

clean:
	@echo "Cleaning..."
	rm -rf $(OUTPUT)
	@echo "Done!"