
function photoCurrentInject(A, tfinish)
  float A
  float tfinish
  float Idark = -0.04e-9
  float tau1 = 0.050
  float tau2 = 0.450
  float tau3 = 0.800
  float b = 3.8

  float Iphoto = 0.0
  float time = {getstat -time}
  echo "time:"  {time}
  while (time <= tfinish)
    time = {getstat -time}
    float Iphoto1 = (32/33)*(1-E**(-time/tau1))
    float Iphoto2Exp = (-(time-b)/tau2)
    float Ievalue = E**Iphoto2Exp
    float Iphoto2 = (1/(1+Ievalue))
    float Iphoto3 = (1-E**(-time/tau3))/33
    float Isum = Iphoto1 - Iphoto2 + Iphoto3

    Iphoto = Idark + A*( Isum )

    echo "time:"  {time} " Iphoto:" {Iphoto}
    setfield /cell/soma inject {Iphoto}
    step
  end


end

function make_Iphotograph
  float vmax = 0
  float vmin = -40e-12
  create xform /input [610,50,350,350]
  create xlabel /input/label -hgeom 10% -label "Photocurrent input"
  create xgraph /input/current -hgeom 90% -title "Photocurrent input"
  setfield ^ XUnits sec YUnits Ampere
  setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
  xshow /input
  addmsg /cell/soma /input/current PLOT inject *current *blue
end



//photoCurrentInject 0.04e-9 {tmax}
