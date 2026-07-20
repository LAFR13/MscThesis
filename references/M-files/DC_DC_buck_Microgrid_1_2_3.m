%DC_DC_buck_Microgrid
clear all
clc

% Data
U=100;
ri=0.01;
DeltaU=2*0.15;
Vo=48;
DeltaVo=2*0.01;
fpwm=10000;
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
Rs=1e6;
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

% Maximization of Constant power load capability

Pom=1.0*Po
DPp=1
for Pp = 1 : DPp : Pom
   
    Rm=0.999*Vo^2/Pp;
    Pres=Pom-Pp-Pomin;
    Reqpp=(Vo^2/Pres)*Rmax/((Vo^2/Pres)+Rmax); %max((Vo^2/Pres)*Rmax/((Vo^2/Pres)+Rmax), Rm);
   if  Reqpp>1.0*Rm %(Pres-DPp-Vo^2/Reqp)<0,   max factor=1.2*Rm
       break
   end  
end
Reqpp
Reqp=Vo^2/(Pres)
Reqpp=Reqp*Rmax/(Reqp+Rmax)
Iop=Pp/Vo
Ios=(Pom-Pp-Pomin-Vo^2/Reqp)/Vo
OUT = [Rmax Rm Reqp Pp Iop Ios];
disp ('     Rmax    Rm       Reqp       Pp         Iop        Ios')
disp (OUT)
Pp
Pos=Vo*Ios
PRmax=Vo^2/Rmax
PReqp=Vo^2/Reqp
PR=PRmax+PReqp

