set search_path [concat "/usr/local/lib/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

#read_verilog module
read_verilog 32I-riscv/top.v

# Analyze & Elaborate Parameterized Modules
analyze -format verilog 32I-riscv/stages/utils/rf32x32.v
elaborate rf32x32

analyze -format verilog 32I-riscv/stages/utils/DW_ram_2r_w_s_dff.v
elaborate DW_ram_2r_w_s_dff

# Top Module
current_design "top"

group_path -to find(cell, "U8/rout_reg[44]/D") -name FOO -weight 10 
set_max_area 0
set_max_fanout 64 [current_design]

create_clock -period 4.75 clk
set_clock_uncertainty -setup 0.0 [get_clock clk]
set_clock_uncertainty -hold 0.0 [get_clock clk]
set_input_delay  0.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.0 -clock clk [remove_from_collection [all_outputs] clk]

set_flatten true -phase true -effort high
set_structure true -boolean true
compile 
compile -map_effort high -area_effort high -incremental_mapping

report_timing -max_paths 1
report_area
report_power

write -hier -format verilog -output HOGEHOGE_PROC.vnet
write -hier -output HOGEHOGE_PROC.db

quit
