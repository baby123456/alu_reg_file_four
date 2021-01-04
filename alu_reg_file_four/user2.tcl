
# device and board
set device xczu19eg-ffvc1760-2-i
set board fidus:none:part0:2.0

#Input Directories
set srcDir     "./Sources"
set rtlDir     "$srcDir/hdl"
set xdcDir     "$srcDir/xdc"

#Output Directories
set synthDir  "./Synth"
set implDir   "./Implement"
set dcpDir    "./Checkpoint"
set bitDir    "./Bitstreams"

set static top

set pm1 user1
set inst_pm1 inst_alu_user1
set pm1_v1 user1

set pm2 user2
set inst_pm2 inst_alu_user2
set pm2_v1 user2

set pm3 user3
set inst_pm3 inst_alu_user3
set pm3_v1 user3

set pm4 user4
set inst_pm4 inst_alu_user4
set pm4_v1 user4

#todo
#current user
set pm user2
set inst_pm inst_alu_${pm}

#set pm_v1 user2
#set pm_v1 adder
set pm_v1 adder

file mkdir $synthDir
file mkdir $synthDir/${pm}
file delete -force $synthDir/${pm}/${pm_v1}
file mkdir $synthDir/${pm}/${pm_v1}

file mkdir $implDir
file mkdir $implDir/${pm}
file delete -force $implDir/${pm}/${pm_v1}
file mkdir $implDir/${pm}/${pm_v1}
file mkdir $implDir/${pm}/${pm_v1}/reports

#file mkdir $dcpDir
file mkdir $dcpDir/${pm}
file delete -force $dcpDir/${pm}/${pm_v1}
file mkdir $dcpDir/${pm}/${pm_v1}

file mkdir $bitDir
file mkdir $bitDir/${pm}
file delete -force $bitDir/${pm}/${pm_v1}
file mkdir $bitDir/${pm}/${pm_v1}

puts "#HD: Running synthesis for block ${pm_v1}"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]
add_files $rtlDir/${pm_v1}/${pm_v1}.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top ${pm_v1} -part ${device}
write_checkpoint -force $synthDir/${pm}/${pm_v1}/${pm_v1}_synth.dcp
report_utilization -file $synthDir/${pm}/${pm_v1}/${pm_v1}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module ${pm_v1} complete\n"

create_project -in_memory -part ${device}
set_property board_part ${board} [current_project]
add_files ${dcpDir}/top_static.dcp
add_files $xdcDir/top_fidus.xdc
set_property USED_IN {implementation} [get_files $xdcDir/top_fidus.xdc]

#todo
add_file ${dcpDir}/${inst_pm4}_${pm4_v1}_route_design.dcp
set_property SCOPED_TO_CELLS { inst_alu_user4 } [get_files ${dcpDir}/${inst_pm4}_${pm4_v1}_route_design.dcp]
add_file ${dcpDir}/${inst_pm3}_${pm3_v1}_route_design.dcp 
set_property SCOPED_TO_CELLS { inst_alu_user3 } [get_files ${dcpDir}/${inst_pm3}_${pm3_v1}_route_design.dcp]
add_file ${dcpDir}/${inst_pm1}_${pm1_v1}_route_design.dcp 
set_property SCOPED_TO_CELLS { inst_alu_user1 } [get_files ${dcpDir}/${inst_pm1}_${pm1_v1}_route_design.dcp]

add_file $synthDir/${pm}/${pm_v1}/${pm_v1}_synth.dcp
set_property SCOPED_TO_CELLS { inst_alu_user2 } [get_files $synthDir/${pm}/${pm_v1}/${pm_v1}_synth.dcp]
link_design -mode default -reconfig_partitions { inst_alu_user4 inst_alu_user3 inst_alu_user1 inst_alu_user2 } -part $device -top $static
write_checkpoint -force ${implDir}/${pm}/${pm_v1}/top_link_design_${pm_v1}.dcp

opt_design
place_design
phys_opt_design
route_design
puts "	#HD: Completed: opt_design,place_design,phys_opt_design,route_design"
write_checkpoint -force $dcpDir/${pm}/${pm_v1}/top_route_design_${pm_v1}.dcp 
report_utilization -file $implDir/${pm}/${pm_v1}/reports/top_utilization_route_design_${pm_v1}.rpt
report_route_status -file $implDir/${pm}/${pm_v1}/reports/top_route_status_${pm_v1}.rpt
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file $implDir/${pm}/${pm_v1}/reports/top_timing_summary_${pm_v1}.rpt
report_drc -ruledeck bitstream_checks -name top -file $implDir/${pm}/${pm_v1}/reports/top_drc_bitstream_checks.rpt
close_project

puts "	#HD: Running write_partBitstream"
open_checkpoint $dcpDir/${pm}/${pm_v1}/top_route_design_${pm_v1}.dcp 
write_bitstream -force  -cell ${inst_pm} $bitDir/${pm}/${pm_v1}/pblock_${inst_pm}_${pm_v1}_partial
close_project 
