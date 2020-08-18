
#-------------------------------------------------
# pblock_inst_user1 for pr instance inst_alu_user1
#-------------------------------------------------
create_pblock pblock_inst_user1
add_cells_to_pblock [get_pblocks pblock_inst_user1] [get_cells -quiet [list inst_alu_user1]]
resize_pblock [get_pblocks pblock_inst_user1] -add CLOCKREGION_X1Y9:CLOCKREGION_X1Y9
resize_pblock [get_pblocks pblock_inst_user1] -add CLOCKREGION_X0Y9:CLOCKREGION_X0Y9

#-------------------------------------------------
# pblock_inst_user2 for pr instance inst_alu_user2
#-------------------------------------------------
create_pblock pblock_inst_user2
add_cells_to_pblock [get_pblocks pblock_inst_user2] [get_cells -quiet [list inst_alu_user2]]
resize_pblock [get_pblocks pblock_inst_user2] -add CLOCKREGION_X0Y10:CLOCKREGION_X0Y10
resize_pblock [get_pblocks pblock_inst_user2] -add CLOCKREGION_X1Y10:CLOCKREGION_X1Y10


#-------------------------------------------------
# pblock_inst_user3 for pr instance inst_alu_user3
#-------------------------------------------------
create_pblock pblock_inst_user3
add_cells_to_pblock [get_pblocks pblock_inst_user3] [get_cells -quiet [list inst_alu_user3]]
resize_pblock [get_pblocks pblock_inst_user3] -add CLOCKREGION_X2Y10:CLOCKREGION_X2Y10
resize_pblock [get_pblocks pblock_inst_user3] -add CLOCKREGION_X3Y10:CLOCKREGION_X3Y10

#-------------------------------------------------
# pblock_inst_user4 for pr instance inst_alu_user4
#-------------------------------------------------
create_pblock pblock_inst_user4
add_cells_to_pblock [get_pblocks pblock_inst_user4] [get_cells -quiet [list inst_alu_user4]]
resize_pblock [get_pblocks pblock_inst_user4] -add CLOCKREGION_X2Y9:CLOCKREGION_X2Y9
resize_pblock [get_pblocks pblock_inst_user4] -add CLOCKREGION_X3Y9:CLOCKREGION_X3Y9

