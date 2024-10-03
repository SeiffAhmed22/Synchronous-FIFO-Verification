vlib work
vlog -f src_files.list -mfcu +define+SIM +cover
vsim -voptargs=+acc work.top -cover
add wave /top/FIFOit/*
coverage save fifocoveragereport.ucdb -onexit -du work.top
run -all