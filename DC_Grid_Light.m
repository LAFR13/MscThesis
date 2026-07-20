% DC_DC_buck_Microgrid
clear all
clc

% Data
U = 100;
r1 = 0.01;
DeltaU = 2 * 0.15;
Vo = 48;
DeltaVo = 2 * 0.01;
fpwm = 100000;
Po = 1500;
Pomin = 100;

% Sets
Voref1 = 200;
Voref2 = 200;
Voref3 = 200;
Voref4 = 200;

% Calculations
Umin = U * (1 - DeltaU/2);
Umax = U * (1 + DeltaU/2);
IoAmin = Pomin / Vo;
deltamin = Vo / Umax;
deltamax = Vo / Umin;

% LC filter
Lf = 1.01 * Vo * (1 - deltamin) / (2 * IoAmin * fpwm);
Cf = 2 * IoAmin / (8 * fpwm * DeltaVo * Vo);

% C for point-of-load
% Load
Rmax = Vo^2 / Pomin;
Ios = Po / 2 / Vo;
Iop = Po / 7 / Vo;

% Semiconductors
Rds0n = 0.1;
Rsnubber = 1e5;
Csnubber = 1e-7;
Ron = 0.1;
Vd = 0.8;

% Inductor Current Linear Control
ucmax=1;
KM = U/ucmax;
Td = 1/(2*fpwm);
Req = Vo^2/Po;
Tz = Lf/Req;
qsii = 0.707;
ki = 1;
Tp = 4*qsii^2*ki*KM*Td/Req;
Kp = Tz/Tp;
Ki = 1/Tp;
% Output Voltage Linear Control
qsiv = 0.85;
alfav = 1;
Tzv = Cf*Req;
Tpv = 8*qsiv^2*Req*alfav*Td;
Kpv = Tzv/Tpv;
Kiv = 1/Tpv;

