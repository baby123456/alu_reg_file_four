#部分可重构流程

#1、设置板卡和FPGA芯片类型,输入和输出目录
# device and board
set device xczu19eg-ffvc1760-2-i
set board fidus:none:part0:2.0
#Input Directories
set srcDir     "./Sources"
set rtlDir     "$srcDir/hdl"
set xdcDir     "$srcDir/xdc"
####Output Directories
set synthDir  "./Synth"
set implDir   "./Implement"
set dcpDir    "./Checkpoint"
set bitDir    "./Bitstreams"

set static top

set pm1 user1
set inst_pm1 inst_alu_user1
set pm1_v1 alu

set pm2 user2
set inst_pm2 inst_alu_user2
set pm2_v1 flag

set pm3 user3
set inst_pm3 inst_alu_user3
set pm3_v1 adder

set pm4 user4
set inst_pm4 inst_alu_user4
set pm4_v1 reg_file

set project_name prj1
set topmodule_src_fpga mpsoc_wrapper
set sub_bd mpsoc
set prj_file ../${project_name}/${project_name}.xpr


# setting up the project
create_project ${project_name} -force -dir "../${project_name}" -part ${device}
set_property board_part ${board} [current_project]
source ../${sub_bd}.tcl
set_property synth_checkpoint_mode None [get_files ../${project_name}/${project_name}.srcs/sources_1/bd/${sub_bd}/${sub_bd}.bd]
generate_target all [get_files ../${project_name}/${project_name}.srcs/sources_1/bd/${sub_bd}/${sub_bd}.bd]
make_wrapper -files [get_files ../${project_name}/${project_name}.srcs/sources_1/bd/${sub_bd}/${sub_bd}.bd] -top
import_files -force -norecurse -fileset sources_1 ../${project_name}/${project_name}.srcs/sources_1/bd/${sub_bd}/hdl/${sub_bd}_wrapper.v
validate_bd_design
save_bd_design
close_bd_design ${sub_bd}
close_project

#2、综合所有静态模块和部分可重构模块
#建立静态逻辑综合目录
file mkdir $synthDir
file delete -force $synthDir/Static
file mkdir $synthDir/Static
#综合顶层静态模块
puts "#HD: Running synthesis for block Static"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]

read_verilog -library xil_defaultlib {
   ../prj1/prj1.srcs/sources_1/bd/mpsoc/hdl/mpsoc_wrapper.v
}
add_files ../${project_name}/${project_name}.srcs/sources_1/bd/${sub_bd}/${sub_bd}.bd
add_files $rtlDir/${static}/${static}.v

synth_design -mode default -flatten_hierarchy rebuilt -top ${static} -part ${device} 
write_checkpoint -force $synthDir/Static/${static}_synth.dcp
report_utilization -file $synthDir/Static/${static}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module Static complete\n"

#建立user1可重构模块综合目录,综合user1可重构模块
file delete -force $synthDir/${pm1}
file mkdir $synthDir/${pm1}
puts "#HD: Running synthesis for block ${pm1_v1}"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]
add_files $rtlDir/${pm1_v1}/${pm1_v1}.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top ${pm1_v1} -part ${device}
write_checkpoint -force $synthDir/${pm1}/${pm1_v1}_synth.dcp
report_utilization -file $synthDir/${pm1}/${pm1_v1}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module ${pm1_v1} complete\n"

#建立user2可重构模块综合目录,综合user2可重构模块
file delete -force $synthDir/${pm2}
file mkdir $synthDir/${pm2}
puts "#HD: Running synthesis for block ${pm2_v1}"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]
add_files $rtlDir/${pm2_v1}/${pm2_v1}.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top ${pm2_v1} -part ${device}
write_checkpoint -force $synthDir/${pm2}/${pm2_v1}_synth.dcp 
report_utilization -file $synthDir/${pm2}/${pm2_v1}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module ${pm2_v1} complete\n"

#建立user3可重构模块综合目录,综合user3可重构模块
file mkdir $synthDir
file delete -force $synthDir/${pm3}
file mkdir $synthDir/${pm3}
puts "#HD: Running synthesis for block ${pm3_v1}"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]
add_files $rtlDir/${pm3_v1}/${pm3_v1}.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top ${pm3_v1} -part ${device}
write_checkpoint -force $synthDir/${pm3}/${pm3_v1}_synth.dcp
report_utilization -file $synthDir/${pm3}/${pm3_v1}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module ${pm3_v1} complete\n"

#建立user4可重构模块综合目录,综合user4可重构模块
file delete -force $synthDir/${pm4}
file mkdir $synthDir/${pm4}
puts "#HD: Running synthesis for block ${pm4_v1}"
create_project -in_memory -part ${device}
set_property source_mgmt_mode All [current_project]
set_property board_part ${board} [current_project]
add_files $rtlDir/${pm4_v1}/${pm4_v1}.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top ${pm4_v1} -part ${device}
write_checkpoint -force $synthDir/${pm4}/${pm4_v1}_synth.dcp 
report_utilization -file $synthDir/${pm4}/${pm4_v1}_utilization_synth.rpt
close_project
puts "#HD: Synthesis of module ${pm4_v1} complete\n"

#static+user1+user2+user3+user4,即 Config_user1_user2_user3_user4_implement
set init_config Config_alu_share_implement
file mkdir $implDir
file delete -force $implDir/${init_config}
file mkdir $implDir/${init_config}
file mkdir $implDir/${init_config}/reports
puts "#HD: Running implementation ${init_config}"

create_project -in_memory -part ${device}
set_property board_part ${board} [current_project]
add_files $synthDir/Static/${static}_synth.dcp
add_files $xdcDir/top_fidus.xdc
set_property USED_IN {implementation} [get_files $xdcDir/top_fidus.xdc]

add_file $synthDir/${pm4}/${pm4_v1}_synth.dcp
set_property SCOPED_TO_CELLS { inst_alu_user4 } [get_files $synthDir/${pm4}/${pm4_v1}_synth.dcp]

add_file $synthDir/${pm3}/${pm3_v1}_synth.dcp
set_property SCOPED_TO_CELLS { inst_alu_user3 } [get_files $synthDir/${pm3}/${pm3_v1}_synth.dcp]

add_file $synthDir/${pm2}/${pm2_v1}_synth.dcp
set_property SCOPED_TO_CELLS { inst_alu_user2 } [get_files $synthDir/${pm2}/${pm2_v1}_synth.dcp]

add_file $synthDir/${pm1}/${pm1_v1}_synth.dcp
set_property SCOPED_TO_CELLS { inst_alu_user1 } [get_files $synthDir/${pm1}/${pm1_v1}_synth.dcp]

link_design -mode default -reconfig_partitions { inst_alu_user4 inst_alu_user3 inst_alu_user2 inst_alu_user1 } -part $device -top $static
write_checkpoint -force $implDir/${init_config}/top_link_design.dcp

opt_design
write_checkpoint -force $implDir/${init_config}/top_opt_design.dcp 

place_design
write_checkpoint -force $implDir/${init_config}/top_place_design.dcp 

phys_opt_design
write_checkpoint -force $implDir/${init_config}/top_phys_opt_design.dcp

route_design
puts "	#HD: Completed: opt_design,place_design,phys_opt_design,route_design"
write_checkpoint -force $implDir/${init_config}/top_route_design.dcp 

#报告利用率、布线状态以及时序
report_utilization -file $implDir/${init_config}/reports/top_utilization_route_design.rpt
report_route_status -file $implDir/${init_config}/reports/top_route_status.rpt
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file $implDir/${init_config}/reports/top_timing_summary.rpt
report_drc -ruledeck bitstream_checks -name top -file $implDir/${init_config}/reports/top_drc_bitstream_checks.rpt

lock_design -level logical -cell ${inst_pm4}
write_checkpoint -force -cell ${inst_pm4} $implDir/${init_config}/${inst_pm4}_${pm4_v1}_route_design.dcp
file copy -force $implDir/${init_config}/${inst_pm4}_${pm4_v1}_route_design.dcp $dcpDir
# 将布线结果中的inst_alu_user4替换为blackbox
update_design -cell ${inst_pm4} -black_box

lock_design -level logical -cell ${inst_pm3}
write_checkpoint -force -cell ${inst_pm3} $implDir/${init_config}/${inst_pm3}_${pm3_v1}_route_design.dcp
file copy -force $implDir/${init_config}/${inst_pm3}_${pm3_v1}_route_design.dcp $dcpDir
# 将布线结果中的inst_alu_user3替换为blackbox
update_design -cell ${inst_pm3} -black_box

lock_design -level logical -cell ${inst_pm2}
write_checkpoint -force -cell ${inst_pm2} $implDir/${init_config}/${inst_pm2}_${pm2_v1}_route_design.dcp
file copy -force $implDir/${init_config}/${inst_pm2}_${pm2_v1}_route_design.dcp $dcpDir
# 将布线结果中的inst_alu_user2替换为blackbox
update_design -cell ${inst_pm2} -black_box

lock_design -level logical -cell $inst_pm1
write_checkpoint -force -cell $inst_pm1 $implDir/${init_config}/${inst_pm1}_${pm1_v1}_route_design.dcp
file copy -force $implDir/${init_config}/${inst_pm1}_${pm1_v1}_route_design.dcp $dcpDir
# 将布线结果中的inst_alu_user1替换为blackbox
update_design -cell ${inst_pm1} -black_box

# 锁定inst_alu_user1,inst_alu_user2,inst_alu_user3,inst_alu_user4,替换为黑盒后的布线结果
lock_design -level routing
write_checkpoint -force $implDir/${init_config}/top_static.dcp
#保存shell的布线结果，供后续role布局布线使用
file copy -force $implDir/${init_config}/top_static.dcp $dcpDir
puts "#HD: Implementation ${init_config} complete\n"
close_project

#5、验证两种配置是否兼容
#puts "#HD: Running pr_verify between initial Configuration '${alter_config}' and subsequent configurations '${init_config}'"
#pr_verify -full_check -initial $implDir/${alter_config}/top_route_design.dcp -additional  $implDir/${init_config}/top_route_design.dcp

#6、生成配置的bit和部分配置bit
puts "	#HD: Running write_bitstream on ${init_config}"
file mkdir $bitDir
open_checkpoint $implDir/${init_config}/top_route_design.dcp 
write_bitstream -force  $bitDir/${init_config}_full -no_partial_bitfile

write_bitstream -force  -cell ${inst_pm4} $bitDir/pblock_${inst_pm4}_${pm4_v1}_partial
write_bitstream -force  -cell ${inst_pm3} $bitDir/pblock_${inst_pm3}_${pm3_v1}_partial
write_bitstream -force  -cell ${inst_pm2} $bitDir/pblock_${inst_pm2}_${pm2_v1}_partial
write_bitstream -force  -cell ${inst_pm1} $bitDir/pblock_${inst_pm1}_${pm1_v1}_partial
close_project 
