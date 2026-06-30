# --- Verilator Project Configuration ---
# Name of your top-level SystemVerilog module
TOP_MODULE = cpu_tb

# List all your SystemVerilog files here
SV_SOURCES = cpu_tb.sv cpu.sv alu.sv control.sv

# Your C++ testbench wrapper file
CPP_SOURCES = sim_main.cpp

# Target executable name
TARGET = V$(TOP_MODULE)

# Toolchain definitions
VERILATOR = verilator
VERILATOR_FLAGS = -Wall --cc --exe --build -j 0 --trace

# --- Build Rules ---

# Default target: compile everything and run the simulation
all: run

# Compile step using Verilator
# This parses the SV, hooks it to the CPP wrapper, and runs GCC to compile the binary
compile: $(SV_SOURCES) $(CPP_SOURCES)
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module $(TOP_MODULE) $(SV_SOURCES) $(CPP_SOURCES)

# Run the simulation binary to generate the waveform
run: compile
	./obj_dir/$(TARGET)

# View the results in GTKWave
view: run
	gtkwave waveform.vcd &

# Clean up build artifacts
clean:
	rm -rf obj_dir waveform.vcd

.PHONY: all compile run view clean
