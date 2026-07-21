% DC public lighting grid parameters
clear
clc

%% Global simulation settings
Ts = 5e-7;

%% ACDC front-end: three-phase PWM rectifier
fac_acdc = 50;
Vac_acdc = 230;              % phase-to-neutral RMS voltage [V]
Scc_acdc = 20e6;
X_R_acdc = 7;
Udc_ref = 350;               % DC bus voltage reference [V]
Pdc_acdc = 4 * 1500;         % nominal DC bus power [W]
Pdcmin_acdc = Pdc_acdc / 10;
DeltaUdc_acdc = 0.02;
fpwm_acdc = (4 * 50 - 1) * fac_acdc;

Ron_acdc = 0.04;
Rs_acdc = 1e6;
Csnubber_acdc = inf;

Rgrid_acdc = 0.8929;
Lgrid_acdc = 16.58e-3;
Rfilter_acdc = 1.33e-2;
ri_acdc = Rfilter_acdc;

Rdcmax_acdc = Udc_ref^2 / Pdcmin_acdc;
Rdc_acdc = Udc_ref^2 / (Pdc_acdc - Pdcmin_acdc);
Cdc_acdc = 2 * Pdc_acdc / ...
    (fac_acdc * (((1 + DeltaUdc_acdc / 2) * Udc_ref)^2 - ...
    ((1 - DeltaUdc_acdc / 2) * Udc_ref)^2));

DeltaIac_acdc = 0.1 * ((Pdc_acdc / 3) / Vac_acdc);
Lfac_acdc = Udc_ref / (6 * fpwm_acdc * DeltaIac_acdc);
wac_acdc = 2 * pi * fac_acdc;
XLf_acdc = wac_acdc * Lfac_acdc;

m_acdc = min(0.95, Vac_acdc / (Udc_ref / (2 * sqrt(2))));
deltafi_acdc = 0;
Gi_acdc = Vac_acdc * sqrt(2) / Udc_ref;

% Current controller for the AC filter current.
alfai_acdc = 1;
Tdi_acdc = 1 / (2 * fpwm_acdc);
Reqi_acdc = Vac_acdc^2 / (Pdc_acdc / 3);
Tzi_acdc = Lfac_acdc / Reqi_acdc;
Tpi_acdc = 2 * alfai_acdc * Tdi_acdc / Reqi_acdc;
Kpi_acdc = Tzi_acdc / Tpi_acdc;
Kii_acdc = 1 / Tpi_acdc;
current_limit_acdc = 200;

% DC voltage controller. The signs follow the previous AC/DC work.
alfav_acdc = 1;
Tdv_acdc = 1 / (2 * fac_acdc);
Kpvdc_acdc = -2.15 * Cdc_acdc * alfai_acdc / ...
    (1.75^2 * alfav_acdc * Gi_acdc * Tdv_acdc);
Kivdc_acdc = -Cdc_acdc * alfai_acdc / ...
    (1.75^3 * alfav_acdc * Gi_acdc * Tdv_acdc^2);
Kwvdc_acdc = sqrt(Kpvdc_acdc * Kivdc_acdc);
id_limit_acdc = 200;

%% DC/DC converters supplied by the 350 V DC bus
U = Udc_ref;
r1 = 0.01;
DeltaU = 2 * 0.15;
Vo = 200;
DeltaVo = 2 * 0.01;
fpwm = 100000;
Po = 1500;
Pomin = 100;

Voref1 = 200;
Voref2 = 200;
Voref3 = 200;
Voref4 = 200;

Umin = U * (1 - DeltaU / 2);
Umax = U * (1 + DeltaU / 2);
IoAmin = Pomin / Vo;
deltamin = Vo / Umax;
deltamax = Vo / Umin;

Lf = 1.01 * Vo * (1 - deltamin) / (2 * IoAmin * fpwm);
Cf = 2 * IoAmin / (8 * fpwm * DeltaVo * Vo);

Rmax = Vo^2 / Pomin;
Ios = Po / 2 / Vo;
Iop = Po / 7 / Vo;

Rds0n = 0.1;
Rsnubber = 1e5;
Csnubber = 1e-7;
Ron = 0.1;
Vd = 0.8;

ucmax = 1;
KM = U / ucmax;
Td = 1 / (2 * fpwm);
Req = Vo^2 / Po;
Tz = Lf / Req;
qsii = 0.707;
ki = 1;
Tp = 4 * qsii^2 * ki * KM * Td / Req;
Kp = Tz / Tp;
Ki = 1 / Tp;

qsiv = 0.85;
alfav = 1;
Tzv = Cf * Req;
Tpv = 8 * qsiv^2 * Req * alfav * Td;
Kpv = Tzv / Tpv;
Kiv = 1 / Tpv;
