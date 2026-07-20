%DC_DC_buck_Microgrid_4
clear all
pack
clc

% Data
U=100;
ri=0.01;
DeltaU=2*0.15;
Vo=48;
DeltaVo=2*0.01;
fpwm=20000;
Po=1500;
Pomin=100;

% Calculations
Umin=U*(1-DeltaU/2)
Umax=U*(1+DeltaU/2)
IoAVmin=Pomin/Vo
deltamin=Vo/Umax
deltaN=Vo/U
deltamax=Vo/Umin

% LC filter
Lf=1.01*Vo*(1-deltamin)/(2*IoAVmin*fpwm)
Cf=2*IoAVmin/(8*fpwm*DeltaVo*Vo)
%C for point-of-load

% Load
Rmax=Vo^2/Pomin
Ios=Po/2/Vo
Iop=Po/7/Vo

% Semiconductors
Rdson=0.1;
Rs=1e5;
Cs=1e-7;
Ron=0.1;
Vd=0.8;

% Inductor Current Linear Control
ucmax=1;
KM=U/ucmax
Td=1/(2*fpwm)
Req=Vo^2/Po
Tz=Lf/Req
qsii=0.707
ki=1
Tp=4*qsii^2*ki*KM*Td/Req
Kp=Tz/Tp
Ki=1/Tp
% Output Voltage Linear Control
qsiv=0.85
alfav=1
Tzv=Cf*Req
Tpv=8*qsiv^2*Req*alfav*Td
Kpv=Tzv/Tpv
Kiv=1/Tpv

% Primary Voltage Droop Control
Vomax=56
Vomin=Vo
Req=Vomin^2/(Po-Pomin)
rLine=0.04

% Output Current  Droop ; Vdcdp=Vomin when Io=Io_nominal=Imax
Imin=IoAVmin
Imax=Po/Vomin
Rdv=-(Vomin-Vomax)/(Imax-Imin)

% Output Power Droop 
% Vdcdp=Vomax-kdv*(Po-Pomin); Vdcdp=Vomin when Po=Po_nominal
kdv=-(Vomin-Vomax)/(Po-Pomin) 


%DC_DC_buck_Microgrid_2 (not interleaved)

% Data
U2=120;
ri2=0.005;
DeltaU2=2*0.15;
Vo2=48;
DeltaVo2=2*0.01;
fpwm2=10000;
Po2=2500;
Pomin2=100;

% Calculations
Umin2=U2*(1-DeltaU2/2)
Umax2=U2*(1+DeltaU2/2)
IoAVmin2=Pomin2/Vo2
deltamin2=Vo2/Umax2
deltaN2=Vo2/U2
deltamax2=Vo2/Umin2

% LC filter
Lf2=1.01*Vo2*(1-deltamin2)/(2*IoAVmin2*fpwm2)
Cf2=2*IoAVmin2/(8*fpwm2*DeltaVo2*Vo2)
%C for point-of-load

% Load
Rmax2=Vo2^2/Pomin2
% Ios2=Po2/2/Vo
% Iop=Po/7/Vo

% Semiconductors
Rdson2=0.1;
Rs2=1e4;
Cs2=1e-7;
Ron2=0.1;
Vd2=0.8;

% Inductor Current Linear Control
ucmax2=1;
KM2=U2/ucmax2
Td2=1/(2*fpwm2)
Req2=Vo2^2/Po2
Tz2=Lf2/Req2
qsii2=0.707
ki2=1
Tp2=4*qsii2^2*ki2*KM2*Td2/Req2
Kp2=Tz2/Tp2
Ki2=1/Tp2

% Output Voltage Linear Control
qsiv2=0.85
alfav2=1
Tzv2=Cf2*Req2
Tpv2=8*qsiv2^2*Req2*alfav2*Td2
Kpv2=Tzv2/Tpv2
Kiv2=1/Tpv2


% Primary Voltage Droop Control 2
rLine2=0.04
Vomax2=56
Vomin2=Vo
% Output Current  Droop ; Vdcdp=Vomax-Rdv*(Io-Iomin)   -Vdcdp=Vomin when Io=Io_nominal=Imax
Imin2=IoAVmin2
Imax2=Po2/Vomin2
Rdv2=-(Vomin2-Vomax2)/(Imax2-Imin2)

% Output Power Droop 
% Vdcdp=Vomax-kdv*(Po-Pomin); Vdcdp=Vomin when Po=Po_nominal
kdv2=-(Vomin2-Vomax2)/(Po2-Pomin2) 
Req2=Vomin2^2/(Po2-Pomin2)


Ioss=(Po+Po2)/Vomin


