% Questions:
% Nacel diameter (dfan+24)
% TW IPPS (seed)
% Range? Sland? BFL = 1.5*Sland

% Notes:
% EASweep = Elastic Axis Sweep (~50% chord)
% FN can be per engine or total depend on your choice
% TODO: Check single engine or total thrust/weight
% WFuse_unit estimation
function geninputs_test(fname_inputs,vars,guessmat)
    % This file generates parameters of the aircraft to solve
    % Use 777-300 as seed to generate result as comparison
    % ===============APIs===============
    varscell = num2cell(vars);
    [AR,AWing] = deal(varscell{:});
    % ===============Inputs===============
    % >>>> Requirements <<<<
    range_req = 4000; % nm
    BFL_req   = 8785; % ft
    Sland_req = 5702;
    % >>>> Vars <<<<
        % Iterations
%     AWing = 1000; % sq ft
%     AR    = 6;   % 
        % Setup
    WPayload  = 90000; % lb
    MWPayload = 140000; % lb
    sweep = 31.6; % quater chord sweep angle deg
    taper = 0.149;
    lFuse  = 2532; % in        %<==============
    dFuse  = 226;  % in
    lNose  = 312; % in
    lTail  = 648; % in
    Neng    = 2;
    TW_IPPS = 3.9;                 %<==============
    lNacel  = 222; % in
    SFC     = 0.508; % lb/(lb-hr)  %<==============
    Nz       = 3.75; % Ultimate load
    TC_avg   = 0.1089; % thickness average
    EASweep  = 31.6; % Not sure what this is
        % Wetted Area
    wetted = 2.05;
        % Delta Weights
    WFuse_unit = 35;   % <===== Not sure
    Htail_AW_trade = 6;
    Vtail_AW_trade = 5;
        % Performance
    WTOCratio = 0.97; % top of climb weight ratio
    Altitude  = 35000; %TODO: different altitude 
    DISA   = 0;
    Mach   = 0.80;
    ReserveRatio = 0.05;
    KRange  = 0.94;
    ROC_TOC = 300; % fpm
    [~,~,~,Thrust_lapse] = AltRho(Altitude,DISA);
    KTO   = 38;
    Clmax = 1.89;
    Clmax_land = 2.49; % landing
    Kland = 20;
    Mu    = 0.45;
    Sigma = 1;
    % >>>> Seed Input <<<<
%     TODO: Take seed wing area and calculate wing weight from area
    AWing_seed = 3805;
    WEmpty_seed  = 264500; % lb
    WFuel_seed = 223378;
    AR_seed      = 9.67;
    K_seed       = 1/(pi*0.80*AR_seed);
    Nz_seed      = 3.81;
    EASweep_seed = 31.6;
    TC_avg_seed  = 0.111;
    taper_seed   = 0.18;
        
    % Estimate wing weight
%     WWing_seed = 81384;%60038;
    MRW_seed   = WEmpty_seed + WFuel_seed + 18000; % +3500 lb diff
    MZFW_seed  = WEmpty_seed + 90500;
    span_seed  = sqrt(AWing_seed*AR_seed); % ft
    WWing_seed = (4.22*AWing_seed) + (1.642e-6*Nz_seed*span_seed^3*sqrt(MRW_seed*MZFW_seed)*...
                 (1+2*taper_seed))/(TC_avg_seed*cosd(EASweep_seed)^2*AWing_seed*(1+taper_seed));
    
    lFuse_seed   = 2232;
    AHtail_seed  = 832.95;%0.21891*AWing; % TODO: check these ratios in design
    AVtail_seed  = 427.96;%0.11247*AWing;
    Thrust_seed  = 64000;
    TW_IPPS_seed = 3.72;
%     Cf_seed      = 0.003; % TODO

    % ===============References===============
    % Stuff calculated from input that is fixed
    % range = 5000;  % nm
    % BFL   = 5000;  % ft
    VTAS   = Mach*sqrt(1.4*1716.49*0.75187*518.67); % fps;
    KTAS   = VTAS/1.688;

    % >>>> Setup <<<<

    % >>>> Wing <<<<
    span  = sqrt(AWing*AR); % ft
    span_overall = 1.04*span; % ft
    Cr    = 2*12*AWing/(span*(1+taper));  % in
    Ct    = Cr*taper; % in
    MAC   = 2/3*Cr*(1+taper+taper^2)/(1+taper); % in

    % >>>> Fuselage <<<<
    AHtail = 0.21891*AWing;  % sq ft
    AVtail = 0.11247*AWing; % sq ft

    % >>>> Engine <<<<
    WEng_seed    = Thrust_seed/TW_IPPS_seed;
    
    % >>>> WETTED AREA <<<<
    AWing_wet  = wetted*AWing;   % sq ft
    AHtail_wet = wetted*AHtail; % sq ft
    AVtail_wet = wetted*AVtail; % sq ft

    rNose = dFuse/2;
    hNose = lNose;
    ogive_R = (rNose^2 + hNose^2)/(2*rNose);
    ogive_D = ogive_R-rNose;
    ANose_ogive = 2*pi*ogive_R*((rNose-ogive_R)*asin(hNose/ogive_R)+hNose)/144;
    ABarrel = ((lFuse-lNose-lTail)*pi*dFuse)/144;

    rTail = dFuse/2;
    hTail = lTail;
    ogive_R = (rTail^2 + hTail^2)/(2*rTail);
    ogive_D = ogive_R-rTail;
    ATail_ogive = 2*pi*ogive_R*((rTail-ogive_R)*asin(hTail/ogive_R)+hTail)/144;

    AFuse_wet  = ATail_ogive + ANose_ogive + ABarrel;

    % >>>> Air Data <<<<
%     [~,~,Sigma] = AltRho(0,0);
    [rho,visc] = AltRho(Altitude,DISA);
    
    Re   = rho*VTAS*Cr/12/visc;
    Reft = Re/Cr*12;
    Cf   = 0.455/(log10(Re)^(2.58)*(1+0.144*Mach^2)^(0.65));
%     Cf_seed      = Cf*1.2300123; % TODO
    Cf_seed = 0.0026*Cf/round(Cf,6);
    K = K_seed*(AR_seed/AR);%1/(pi*(1/(pi*K_seed*AR_seed))*AR);

    % >>>> DELTA WEIGHTS <<<<
    DeltaWFuse = WFuse_unit*(lFuse-lFuse_seed);
    DeltaWHtail = -AHtail_seed*Htail_AW_trade+Htail_AW_trade*AHtail;
    DeltaWVtail = -AVtail_seed*Vtail_AW_trade+Vtail_AW_trade*AVtail;

    % >>>> PERFORMANCE <<<<
    q = 0.5*rho*VTAS^2;
        % landing
    Sair = (50-15)/tand(3)+(15-0)/tand(1.5); % Landing Air Distance
    MLDW_calc = ((Sland_req-Sair)/Kland)*AWing*Mu*Sigma*Clmax_land;
    MLDW_WingLoad_calc = MLDW_calc/AWing;
    
    % =============Save content=================
    save(fname_inputs);
end

% Find density at certain altitude
function [rho,viscosity,sigma,delta] = AltRho(h,DISA)
    
    if h<36089
        theta = 1-6.87535e-6*h+DISA;
        delta = theta^5.2561;
    else
        theta = 0.75187+DISA;
        delta = 0.22336*exp((36089-h)/20806.7);
    end
    sigma = delta/theta;
    
    temperature = 518.67*theta;
    rho = 0.0023769*sigma;
    viscosity = (2.2697e-8*temperature^1.5)/(temperature+198.72);
    
    
end