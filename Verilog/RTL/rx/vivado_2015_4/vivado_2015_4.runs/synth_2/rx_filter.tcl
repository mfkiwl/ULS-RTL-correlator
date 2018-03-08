# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z010clg400-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/joao/Desktop/Tese/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.cache/wt [current_project]
set_property parent.project_path C:/Users/joao/Desktop/Tese/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
read_verilog -library xil_defaultlib C:/Users/joao/Desktop/Tese/Verilog/RTL/rx/src/rx_filter.v
synth_design -top rx_filter -part xc7z010clg400-1 -cascade_dsp force
write_checkpoint -noxdef rx_filter.dcp
catch { report_utilization -file rx_filter_utilization_synth.rpt -pb rx_filter_utilization_synth.pb }
