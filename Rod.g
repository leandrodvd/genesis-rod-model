/*======================================================================
  A sample script to create a rod compartment containing channels.
  SI units are used.
  ======================================================================*/

include constants
include rodchannels
include photocurrent
//include hhchan


float tmax = 8.0		// simulation time in sec
float dt = 0.0001		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

//===============================
//      Function Definitions
//===============================

function makecompartment(path, length, dia, Erest)
    str path
    float length, dia, Erest
    float area = length*PI*dia
    float xarea = PI*dia*dia/4

    create      compartment     {path}
    setfield    {path}              \
		Em      { Erest }   \           // volts
		Rm 	{ Rm } \		// Ohms
		Cm 	{ Cm } \		// Farads
		Ra      { Ra } 	// Ohms
end

function step_tmax
    step {tmax} -time

    showfield /cell/soma -all
end


//===============================
//    Graphics Functions
//===============================

function make_control
    create xform /control [10,50,250,350]
    create xlabel /control/label -hgeom 50 -bg cyan -label "CONTROL PANEL"
    create xbutton /control/RESET -wgeom 33%       -script reset
    create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax

    create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
    create xbutton /control/PHOTOCURRENT_0.04  -script "photoCurrentInject 0.04e-9 6.0"
    create xbutton /control/PHOTOCURRENT_0.03  -script "photoCurrentInject 0.03e-9 6.0"
    create xbutton /control/PHOTOCURRENT_0.02  -script "photoCurrentInject 0.02e-9 6.0"
    create xbutton /control/PHOTOCURRENT_0.01  -script "photoCurrentInject 0.01e-9 6.0"
    create xbutton /control/PHOTOCURRENT_0.001  -script "photoCurrentInject 0.001e-9 6.0"
    xshow /control
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,350,350]
    create xlabel /data/label -hgeom 10% -label "Soma with H, Kv, Kx and Channels"
    create xgraph /data/voltage  -hgeom 90%  -title "Membrane Potential"
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    xshow /data
    showfield /data/voltage -a
end

function set_inject(dialog)
    str dialog
    setfield /cell/soma inject {getfield {dialog} value}
end

//===============================
//         Main Script
//===============================

create neutral /cell
// create the soma compartment "/cell/soma"
makecompartment /cell/soma {soma_l} {soma_d} {Eleak}
setfield /cell/soma initVm {EREST_ACT} // initialize Vm to rest potential

// provide current injection to the soma
setfield /cell/soma inject  0.3e-9      // 0.3 nA injection current

// Create  channels
pushe /cell/soma
//make_Na_squid_hh
//make_K_squid_hh
make_H_channel_hh
make_Kv_channel_hh
make_Kx_channel_hh
make_Ca_channel_hh
pope

// The soma needs to know the value of the channel conductance
// and equilibrium potential in order to calculate the current
// through the channel.  The channel calculates its conductance
// using the current value of the soma membrane potential.

//addmsg /cell/soma/Na_squid_hh /cell/soma CHANNEL Gk Ek
//addmsg /cell/soma /cell/soma/Na_squid_hh VOLTAGE Vm
//addmsg /cell/soma/K_squid_hh /cell/soma CHANNEL Gk Ek
//addmsg /cell/soma /cell/soma/K_squid_hh VOLTAGE Vm


addmsg /cell/soma/H_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/H_channel_hh VOLTAGE Vm

addmsg /cell/soma/Kv_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Kv_channel_hh VOLTAGE Vm

addmsg /cell/soma/Kx_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Kx_channel_hh VOLTAGE Vm

addmsg /cell/soma/Ca_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Ca_channel_hh VOLTAGE Vm


// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg /cell/soma /data/voltage PLOT Vm *volts *red

//make_Iphotograph

float vmax = 0
float vmin = -8e-11
create xform /input [610,50,350,350]
create xlabel /input/label -hgeom 10% -label "Photocurrent input"
create xgraph /input/current -hgeom 90% -title "Photocurrent input"
setfield ^ XUnits sec YUnits Ampere
setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
xshow /input
addmsg /cell/soma /input/current PLOT inject *current *blue

check
reset
