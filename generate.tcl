
set idx 0
foreach net [get_bd_intf_nets arch/test_sus/*] {
	set m [get_bd_intf_pins -of_objects $net -filter "NAME =~ m* || NAME =~ M*"]
	set s [get_bd_intf_pins -of_objects $net -filter "NAME =~ s* || NAME =~ S*"]
	puts $m
	puts $s

	set reg [create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 arch/test_sus/reg$idx]
	set_property -dict [list \
	  CONFIG.NUM_SLR_CROSSINGS {1} \
	  CONFIG.PIPELINES_MASTER {2} \
	  CONFIG.PIPELINES_SLAVE {2} \
	  CONFIG.REG_CONFIG {15} \
	] $reg

	delete_bd_objs $net
	connect_bd_intf_net $m [get_bd_intf_pins $reg/S_AXIS]
	connect_bd_intf_net $s [get_bd_intf_pins $reg/M_AXIS]
	connect_bd_net [get_bd_pins arch/test_sus/aclk] [get_bd_pins $reg/aclk]
	connect_bd_net [get_bd_pins arch/test_sus/aresetn] [get_bd_pins $reg/aresetn]
	incr idx
}



foreach reg [get_bd_cells arch/test_sus/reg*] {
	set m_net [get_bd_intf_nets -of_objects [get_bd_intf_pins $reg/M_AXIS]]
	set s_net [get_bd_intf_nets -of_objects [get_bd_intf_pins $reg/S_AXIS]]
	set m [get_bd_intf_pins -of_objects $s_net -filter "NAME =~ m* || NAME =~ M*"]
	set s [get_bd_intf_pins -of_objects $m_net -filter "NAME =~ s* || NAME =~ S*"]
	puts $m
	puts $s
	delete_bd_objs $reg
	connect_bd_intf_net $m $s
}
