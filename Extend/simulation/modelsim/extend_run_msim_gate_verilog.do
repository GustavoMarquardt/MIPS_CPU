transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {extend.vo}

vlog -vlog01compat -work work +incdir+E:/TRABALHO_ODILON/MIPS_CPU/Extend {E:/TRABALHO_ODILON/MIPS_CPU/Extend/extend_TB.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  extend_TB

add wave *
view structure
view signals
run -all
