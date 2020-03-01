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
    BFL_req   = 9000; % ft
    Sland_req = 8500;
    % >>>> Vars <<<<
        % Iterations
%     AWing = 1000; % sq ft
%     AR    = 6;   % 
        % Setup
    WPayload  = 94300; % lb
    MWPayload = 150000; % lb
    sweep = 25; % quater chord sweep angle deg
    taper = 0.150;
    lFuse  = 2645; % in        %<==============
    dFuse  = 244;  % in
    lNose  = 277; % in
    lTail  = 556; % in
    Neng    = 2;
    TW_IPPS = 3.75;                 %<==============
    lNacel  = 250; % in
    SFC     = 0.508; % lb/(lb-hr)  %<==============
    Nz       = 3.75; % Ultimate load
    TC_avg   = 0.1089; % thickness average
    EASweep  = 25; % Not sure what this is
        % Wetted Area
    wetted = 2.05;
        % Delta Weights
    WFuse_unit = 33;   % <===== Not sure
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
%     Sigma = 1;
    
    % >>>> Seed Input <<<<
    seedval = seed788();
    [WWing_seed,lFuse_seed,AHtail_seed,AVtail_seed,Thrust_seed,...
        TW_IPPS_seed,K_seed,AR_seed,WEmpty_seed] = deal(seedval{:});

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
    ogive_Rn = (rNose^2 + hNose^2)/(2*rNose);
    ogive_Dn = ogive_Rn-rNose;
    ANose_ogive = 2*pi*ogive_Rn*((rNose-ogive_Rn)*asin(hNose/ogive_Rn)+hNose)/144;
    ABarrel = ((lFuse-lNose-lTail)*pi*dFuse)/144;

    rTail = dFuse/2;
    hTail = lTail;
    ogive_Rt = (rTail^2 + hTail^2)/(2*rTail);
    ogive_Dt = ogive_Rt-rTail;
    ATail_ogive = 2*pi*ogive_Rt*((rTail-ogive_Rt)*asin(hTail/ogive_Rt)+hTail)/144;

    AFuse_wet  = ATail_ogive + ANose_ogive + ABarrel;

    % >>>> Air Data <<<<
    [~,~,Sigma] = AltRho(0,15/288)
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
        delta = (theta-DISA)^5.2561;
    else
        theta = 0.75187+DISA;
        delta = 0.22336*exp((36089-h)/20806.7);
    end
    sigma = delta/theta;
    
    temperature = 518.67*theta;
    rho = 0.0023769*sigma;
    viscosity = (2.2697e-8*temperature^1.5)/(temperature+198.72);
    
    
end