transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {control.vo}

vlog -vlog01compat -work work +incdir+E:/TRABALHO_ODILON/MIPS_CPU/Control {E:/TRABALHO_ODILON/MIPS_CPU/Control/control_TB.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  control_TB

add wave *
view structure
view signals
run -all
