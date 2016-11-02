//MODEL PARAMETERS

//general constants
float PI  = 3.14159
int EXPONENTIAL =   1
int SIGMOID     =   2
int LINOID      =   3

//Passive Parameters
float Rm = 0.06 //Ohms m^2 (original value 600 Ohms cm^2)
float Cm = 0.01 //Farads/m^2 (original value 1uF/cm^2)
float Ra = 0.02 // Ohms m^2 (original value 200 Ohms cm^2)
float Gl = 0.0497 // Siemens/m^ 2  (original value 4.97 10^-6 S/cm^2)

//Parameters of ionic currents
float Eh =-0.032 //Volts
float Ek =-0.074 //Volts
float Eca =0.040 //Volts
float Gh_max = 91 //S/m^ 2
float Gkv_max = 10 //S/m^ 2
float Gkx_max = 4 //S/m^ 2
float Gca_max = 5 //S/m^ 2
float a1 = 0.3 //msˆ-1
float a2 = 0.3 //msˆ-1
float b1 = 0.098 //V
float b2 = 0.030 //V
float c1 = 0.010 //V
float c2 = 0.020 //V

//Soma dimensions
float soma_diameter = 0.000006 //m
float soma_length = 0.0001//100um
float SOMA_A ={ PI * soma_diameter * soma_length}
echo " soma area:"  {SOMA_A}

//simulation parameters
str tmax = 8
setclock 0 0.0001

//controls parameters
//float vmin = -0.1
//float vmax = -0.03

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
  float vmin = -0.04
  float vmax = -0.02
  create xform /data [260,50,350,350]
  create xlabel /data/label -hgeom 10% -label "Soma with Ca, K and H channels"
  create xgraph /data/voltage -hgeom 90% -title "Membane Potential"
  setfield ^ XUnits sec YUnits Volts
  setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
  xshow /data
end

function makeHChannel
/* H  channel: Xpower = 1, Ypower = 0 (n^1)*/
  if ({exists H_channel_hh})
    return
  end
  echo "make H channel "

  float alpha_A = a1
  float alpha_B = c1
  float alpha_V0 = -1 * b1
  float beta_A = a2
  float beta_B = -1 * c2
  float beta_V0 = -1 * b2

  echo "X_alpha_A:" {alpha_A}
  echo "X_alpha_B:" {alpha_B}
  echo "X_alpha_V0:"{alpha_V0}
  echo "X_beta_A:"  {beta_A}
  echo "X_beta_B:"  {beta_B}
  echo "X_beta_V0:" {beta_V0}

  create		hh_channel	H_channel_hh
  setfield H_channel_hh \
    Ek 		{Eh} \			// V
    Gbar		{ {Gh_max} * SOMA_A } \		// S
    Xpower		1.0 \
    Ypower		0.0 \
    X_alpha_FORM	{SIGMOID} \
    X_alpha_A	{alpha_A} \			// 1/V-sec
    X_alpha_B	{alpha_B} \			// V
    X_alpha_V0	{ alpha_V0 } \		// V
    X_beta_FORM	{SIGMOID} \
    X_beta_A	{beta_A} \				// 1/sec
    X_beta_B	{beta_B} \			// V
    X_beta_V0	{beta_V0 }		// V
end

function makeKvChannel
/* Kv  channel: Xpower = 3, Ypower = 1 (m^3 h^1)*/
  if ({exists Kv_channel_hh})
    return
  end
  echo "make Kv channel "

  int X_alpha_FORM = LINOID
  float X_alpha_A = 0.5
  float X_alpha_B = 0.042
  float X_alpha_V0 = 0.100

  int X_beta_FORM = EXPONENTIAL
  float X_beta_A = 0.9
  float X_beta_B = 0.040
  float X_beta_V0 = 0.020

  int Y_alpha_FORM = EXPONENTIAL
  float Y_alpha_A = 0.015
  float Y_alpha_B = 0.022
  float Y_alpha_V0 = 0.0

  int Y_beta_FORM = SIGMOID
  float Y_beta_A = 0.04125
  float Y_beta_B = 0.007
  float Y_beta_V0 = 0.010


  echo "X_alpha_A:" {X_alpha_A}
  echo "X_alpha_B:" {X_alpha_B}
  echo "X_alpha_V0:"{X_alpha_V0}
  echo "X_beta_A:"  {X_beta_A}
  echo "X_beta_B:"  {X_beta_B}
  echo "X_beta_V0:" {X_beta_V0}

  echo "Y_alpha_A:" {Y_alpha_A}
  echo "Y_alpha_B:" {Y_alpha_B}
  echo "Y_alpha_V0:"{Y_alpha_V0}
  echo "Y_beta_A:"  {Y_beta_A}
  echo "Y_beta_B:"  {Y_beta_B}
  echo "Y_beta_V0:" {Y_beta_V0}

  create		hh_channel	Kv_channel_hh
  setfield Kv_channel_hh \
    Ek 		{Eh} \			// V
    Gbar		{ {Gkv_max} * SOMA_A } \		// S
    Xpower		3.0 \
    Ypower		1.0 \
    X_alpha_FORM	{X_alpha_FORM} \
    X_alpha_A	{X_alpha_A} \			// 1/V-sec
    X_alpha_B	{X_alpha_B} \			// V
    X_alpha_V0	{ X_alpha_V0 } \		// V
    X_beta_FORM	{X_beta_FORM} \
    X_beta_A	{X_beta_A} \				// 1/sec
    X_beta_B	{X_beta_B} \			// V
    X_beta_V0	{X_beta_V0 } \		// V
    Y_alpha_FORM	{Y_alpha_FORM} \
    Y_alpha_A	{Y_alpha_A} \			// 1/V-sec
    Y_alpha_B	{Y_alpha_B} \			// V
    Y_alpha_V0	{Y_alpha_V0 } \		// V
    Y_beta_FORM	{Y_beta_FORM} \
    Y_beta_A	{Y_beta_A} \				// 1/sec
    Y_beta_B	{Y_beta_B} \			// V
    Y_beta_V0	{Y_beta_V0 } 		// V
end

//Build SOMA
create neutral /cell
create compartment /cell/soma

setfield /cell/soma Rm {Rm} Cm {Cm} Em {Eh} dia {soma_diameter} len {soma_length}

showfield /cell/soma -all
showfield /cell/soma Vm

//build ionic channels
pushe /cell/soma
makeHChannel
makeKvChannel
pope

//connect ionic channels and soma
echo "connect ionic channels to soma"
//h channel
addmsg /cell/soma/H_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/H_channel_hh VOLTAGE Vm

//Kv channel
addmsg /cell/soma/Kv_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Kv_channel_hh VOLTAGE Vm

//build control
make_control

//build graphs
make_Vmgraph

addmsg /cell/soma /data/voltage PLOT Vm *volts *red
//addmsg /cell/soma /data/voltage PLOT inject *current *blue

check

reset

step 100
