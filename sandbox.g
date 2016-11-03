//MODEL PARAMETERS

//general constants
float PI  = 3.14159
float E = 2.71828
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


//Soma dimensions
float soma_diameter = 0.000006 //m
float soma_length = 0.00005//50um
float SOMA_A ={ PI * soma_diameter * soma_length}
echo " soma area:"  {SOMA_A}

//simulation parameters
str tmax = 8
setclock 0 0.1

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

function photoCurrentInject(A, tfinish)
  float A
  float tfinish
  float Idark = -0.04e-9
  float tau1 = 0.050
  float tau2 = 0.450
  float tau3 = 0.800
  float b = 3.8

  float Iphoto =0
  float time = {getstat -time}
  echo "time:"  {time}
  while (time <= tfinish)
    time = {getstat -time}
    float Iphoto1 = (32/33)*(1-E**(-time/tau1))
    echo "Iphoto1:" {Iphoto1}
    float Iphoto2Exp = (-(time-b)/tau2)
    echo "Iphoto2Exp" {Iphoto2Exp}
    float Ievalue = E**Iphoto2Exp
    echo "Ievalue:"  {Ievalue}
    float Iphoto2 = (1/(1+Ievalue))
    echo "Iphoto2:" {Iphoto2}
    float Iphoto3 = (1-E**(-time/tau3))/33
    echo "Iphoto3:" {Iphoto3}
    float Isum = Iphoto1 - Iphoto2 + Iphoto3

    Iphoto = Idark + A*( Isum )
  /*  if(Isum < 0 )
      Iphoto = Idark
    end*/
    echo "time:"  {time} " Iphoto:" {Iphoto}
    setfield /cell/soma inject {Iphoto}
    step
  end


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
  float vmax = -0.0
  float vmin = -0.100
  create xform /data [260,50,350,350]
  create xlabel /data/label -hgeom 10% -label "Soma with Ca, Kx, Kv and H channels"
  create xgraph /data/voltage -hgeom 90% -title "Membane Potential"
  setfield ^ XUnits sec YUnits Volts
  setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
  xshow /data
  addmsg /cell/soma /data/voltage PLOT Vm *volts *red
end

function make_Iphotograph
  float vmax = 0
  float vmin = -8e-11
  create xform /input [610,50,350,350]
  create xlabel /input/label -hgeom 10% -label "Photocurrent input"
  create xgraph /input/current -hgeom 90% -title "Photocurrent input"
  setfield ^ XUnits sec YUnits Ampere
  setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
  xshow /input
  addmsg /cell/soma /input/current PLOT inject *current *blue
end


function makeHChannel
/* H  channel: Xpower = 1, Ypower = 0 (n^1)*/
  if ({exists H_channel_hh})
    return
  end
  echo "make H channel "

  float a1 = 0.3 //msˆ-1
  float a2 = 0.3 //msˆ-1
  float b1 = 0.098 //V
  float b2 = 0.030 //V
  float c1 = 0.010 //V
  float c2 = 0.020 //V

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
    Ek 		{Ekv} \			// V
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

function makeCaChannel
/* Model Based on Ca channels L-Type Calcium Conductance from article Effects of Tetraethylammonium on Kx Channels and Simulated
Light Response in Rod Photoreceptors */
/* Ca  channel: Xpower = 1, Ypower = 1 (m^1 h^1)*/
  if ({exists Ca_channel_hh})
    return
  end
  echo "make Ca channel "

  int X_alpha_FORM = EXPONENTIAL
  float X_alpha_A = 0.1 //Alpha0.5,Ca from article model
  float X_alpha_B = 0.012 //2SmCa from article model
  float X_alpha_V0 = -0.010  //V0.5,mCa from article model

  // X_beta is equals to X_alpha
  int X_beta_FORM = X_alpha_FORM
  float X_beta_A = X_alpha_A
  float X_beta_B = X_alpha_B
  float X_beta_V0 = X_alpha_V0

  int Y_alpha_FORM = EXPONENTIAL
  float Y_alpha_A = 0.01 //Gama0.5,Ca
  float Y_alpha_B = 0.018 //2S,hCa
  float Y_alpha_V0 = 0.011 //V0.5,hCa

  int Y_beta_FORM = EXPONENTIAL
  float Y_beta_A = 0.0005 //Delta0.5,Ca
  float Y_beta_B = 0.018 //2S,hCa
  float Y_beta_V0 = 0.011 //V0.5,hCa


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

  create		hh_channel	Ca_channel_hh
  setfield Ca_channel_hh \
    Ek 		{Eca} \			// V
    Gbar		{ {Gca_max} * SOMA_A } \		// S
    Xpower		1.0 \
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

function makeKxChannel
/* Model Based on Kx channels L-Type Calcium Conductance from article Effects of Tetraethylammonium on Kx Channels and Simulated
Light Response in Rod Photoreceptors */
/* Kx  channel: Xpower = 1, Ypower = 0 (n^1)*/
  if ({exists Kx_channel_hh})
    return
  end
  echo "make Kx channel "

  int X_alpha_FORM = EXPONENTIAL
  float X_alpha_A = 0.00066 //Alpha0.5,Kx from article model
  float X_alpha_B = 0.0114 //2SmKx from article model
  float X_alpha_V0 = -0.050  //V0.5,mKx from article model

  // X_beta is equals to X_alpha
  int X_beta_FORM = X_alpha_FORM
  float X_beta_A = X_alpha_A
  float X_beta_B = X_alpha_B
  float X_beta_V0 = X_alpha_V0


  echo "X_alpha_A:" {X_alpha_A}
  echo "X_alpha_B:" {X_alpha_B}
  echo "X_alpha_V0:"{X_alpha_V0}
  echo "X_beta_A:"  {X_beta_A}
  echo "X_beta_B:"  {X_beta_B}
  echo "X_beta_V0:" {X_beta_V0}


  create		hh_channel	Kx_channel_hh
  setfield Kx_channel_hh \
    Ek 		{Ekx} \			// V
    Gbar		{ {Gkx_max} * SOMA_A } \		// S
    Xpower		1.0 \
    Ypower		0.0 \
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
makeKxChannel
makeCaChannel
pope

//connect ionic channels and soma
echo "connect ionic channels to soma"
//h channel
addmsg /cell/soma/H_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/H_channel_hh VOLTAGE Vm

//Kv channel
addmsg /cell/soma/Kv_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Kv_channel_hh VOLTAGE Vm

//Kx channel
addmsg /cell/soma/Kx_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Kx_channel_hh VOLTAGE Vm

//Ca channel
addmsg /cell/soma/Ca_channel_hh /cell/soma CHANNEL Gk Ek
addmsg /cell/soma /cell/soma/Ca_channel_hh VOLTAGE Vm



//build control
make_control

//build graphs
make_Vmgraph
make_Iphotograph

//addmsg /cell/soma /data/voltage PLOT inject *current *blue

check

reset

photoCurrentInject 0.04e-9 {tmax}
