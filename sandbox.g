create neutral /cell
create compartment /cell/soma

setfield /cell/soma Rm 10
setfield /cell/soma Cm 2 Em 25 inject 5

showfield /cell/soma -all
showfield /cell/soma Vm

create xform /data
create xgraph /data/voltage
create xbutton /data/RUN -script "step 100"
create xbutton /data/RESET -script "reset"
create xbutton /data/QUIT -script "quit"

xshow /data

addmsg /cell/soma /data/voltage PLOT Vm *volts *red
addmsg /cell/soma /data/voltage PLOT inject *current *blue



check

reset

step 100
