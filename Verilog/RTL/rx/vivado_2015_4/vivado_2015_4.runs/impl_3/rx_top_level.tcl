proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  open_checkpoint C:/Users/joao/Downloads/work/ULS-RTL/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.runs/impl_3/rx_top_level.dcp
  set_property webtalk.parent_dir C:/Users/joao/Downloads/work/ULS-RTL/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.cache/wt [current_project]
  set_property parent.project_path C:/Users/joao/Downloads/work/ULS-RTL/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.xpr [current_project]
  set_property ip_repo_paths c:/Users/joao/Downloads/work/ULS-RTL/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.cache/ip [current_project]
  set_property ip_output_repo c:/Users/joao/Downloads/work/ULS-RTL/Verilog/RTL/rx/vivado_2015_4/vivado_2015_4.cache/ip [current_project]
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force rx_top_level_opt.dcp
  report_drc -file rx_top_level_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file rx_top_level.hwdef}
  place_design 
  write_checkpoint -force rx_top_level_placed.dcp
  report_io -file rx_top_level_io_placed.rpt
  report_utilization -file rx_top_level_utilization_placed.rpt -pb rx_top_level_utilization_placed.pb
  report_control_sets -verbose -file rx_top_level_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force rx_top_level_routed.dcp
  report_drc -file rx_top_level_drc_routed.rpt -pb rx_top_level_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file rx_top_level_timing_summary_routed.rpt -rpx rx_top_level_timing_summary_routed.rpx
  report_power -file rx_top_level_power_routed.rpt -pb rx_top_level_power_summary_routed.pb
  report_route_status -file rx_top_level_route_status.rpt -pb rx_top_level_route_status.pb
  report_clock_utilization -file rx_top_level_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

