# setup_project.tcl
project_new Arise_Ember -overwrite

# Set the device family and part: Cyclone II EP2C20F484C7
set_global_assignment -name FAMILY "Cyclone II"
set_global_assignment -name DEVICE EP2C20F484C7

# Set the top-level entity
set_global_assignment -name TOP_LEVEL_ENTITY core

# Add al Verilog files
set_global_assignment -name VERILOG_FILE ../core.v
set_global_assignment -name VERILOG_FILE ../alu.v
set_global_assignment -name VERILOG_FILE ../decoder.v
set_global_assignment -name VERILOG_FILE ../mem.v
set_global_assignment -name VERILOG_FILE ../thread.v
set_global_assignment -name VERILOG_FILE ../istate.v
set_global_assignment -name VERILOG_FILE ../regfile.v

set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005
set_global_assignment -name FITTER_EFFORT "FAST FIT"
set_global_assignment -name NUM_PARALLEL_PROCESSORS 1


project_close

