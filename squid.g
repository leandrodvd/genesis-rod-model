//MODEL PARAMETERS

//general constants
float PI  = 3.14159
float E = 2.71828
int EXPONENTIAL =   1
int SIGMOID     =   2
int LINOID      =   3

//Passive Parameters
float Rm = 0.33333 //Ohms m^2 (original value 600 Ohms cm^2)
float Cm = 0.01 //Farads/m^2 (original value 1uF/cm^2)
float Ra = 0.3 // Ohms m^2 (original value 200 Ohms cm^2)

//Soma dimensions
float soma_diameter = 30e-6 //m
float soma_length = 30e-6//50um
float SOMA_A ={ PI * soma_diameter * soma_length}
echo " soma area:"  {SOMA_A}


//Squid params
float EREST_ACT = -0.07
float Eleak = EREST_ACT + 0.0106
float ENA = 0.045
float EK = -0.082


//simulation parameters
str tmax = 8
setclock 0 0.1


//functions declaration

function step_tmax
  step {tmax} -t
end

function set_inject(dialog)
  str dialog
  echo "Set inject to " {getfield {dialog} value}
  setfield /cell/soma inject {getfield {dialog} value}
end

function make_control
  create xform /control [10,50,250,145]
  create xlabel /control/label -hgeom 50 -bg cyan -label "CONTROL PANEL"
  create xbutton /control/RESET -wgeom 33% -script reset
  create xbutton /control/RUN -xgeom 0:RESET -ygeom 0:label -wgeom 33% -script step_tmax
  create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% -script quit
  create xdialog /control/Injection -label "Injection(amperes)" -value 0.04e-9 -script "set_inject <widget>"
  xshow /control
end

function make_Vmgraph
  float vmax = 0.100
  float vmin = -0.100
  create xform /data [260,50,350,350]
  create xlabel /data/label -hgeom 10% -label "Soma with Ca, Kx, Kv and H channels"
  create xgraph /data/voltage -hgeom 90% -title "Membane Potential"
  setfield ^ XUnits sec YUnits Volts
  setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
  xshow /data
  addmsg /cell/soma /data/voltage PLOT Vm *volts *red
end

//Build SQUID SOMA

create neutral /cell
create compartment /cell/soma {soma_length} {soma_diameter} {Eleak}
setfield /cell/soma inject 0.3e-9

//setfield /cell/soma Rm {Rm} Cm {Cm} Em {Eh} dia {soma_diameter} len {soma_length}

showfield /cell/soma -all
showfield /cell/soma Vm


//build control
make_control

//build graphs
make_Vmgraph

//addmsg /cell/soma /data/voltage PLOT inject *current *blue

check

reset

step_tmax
