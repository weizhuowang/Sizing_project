
function geninputs_AIAA(fname_inputs,vars)
    % This file generates parameters of the aircraft to solve
    % Use 777-200 as seed
    % ===============APIs===============
    varscell = num2cell(vars);
    [AR,AWing] = deal(varscell{:});
    % ===============Inputs===============
    % >>>> Requirements <<<<
    range_req = 4000; % nm
    BFL_req   = 9000; % ft
    Sland_req = 9000;
    % >>>> Vars <<<<
        % Iterations
%     AWing = 1000; % sq ft
%     AR    = 6;   % 
        % Setup
    WPayload  = 134300; % lb
    MWPayload = 134300; % lb
    sweep = 32.2; % quater chord sweep angle deg
    taper = 0.149;
    lFuse  = 46/0.0254; % in        %<==============
    dFuse  = 6.2/0.0254;  % in
    lNose  = 3.9/0.0254; % in
    lTail  = 16.4/0.0254; % in
    Neng    = 2;
    TW_IPPS = 3.52;                 %<==============
    lNacel  = 7.3/0.0254; % in
    SFC     = 0.5279; % lb/(lb-hr)  %<==============
    Nz       = 4.0; % Ultimate load
    TC_avg   = 0.085; % thickness average
    EASweep  = 32.2; % Not sure what this is
        % Wetted Area
    wetted = 2.05;
        % Delta Weights
    WFuse_unit = 25;
    Htail_AW_trade = 6;
    Vtail_AW_trade = 5;
        % Performance
    WTOCratio = 0.97; % top of climb weight ratio
    Altitude  = 37000; %TODO: different altitude 
    DISA   = 0;
    Mach   = 0.90;
    ReserveRatio = 0.05;
    KRange  = 0.96;
    ROC_TOC = 300; % fpm
    Thrust_lapse = 0.2;
    KTO   = 38;
    Clmax = 1.45;
    Clmax_land = 2.43; % landing
    Kland = 20;
    Mu    = 0.45;
    Sigma = 1;
    % >>>> Seed Input <<<<
    WEmpty_seed  = 300000; % lb
    K_seed       = 0.06;
    AR_seed      = 8.67;
    WWing_seed   = 60038;
    lFuse_seed   = 48/0.0254;
    AHtail_seed  = 101.26*10.771;%0.25*AWing;
    AVtail_seed  = 53.23*10.771;%0.125*AWing;
    Thrust_seed  = 76000;
    TW_IPPS_seed = 3.52;
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
    AHtail = 0.25*AWing;  % sq ft
    AVtail = 0.125*AWing; % sq ft

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
    [rho,visc] = AltRho(Altitude,DISA);
    
    Re   = rho*VTAS*Cr/12/visc;
    Reft = Re/Cr*12;
    Cf   = 0.455/(log10(Re)^(2.58)*(1+0.144*Mach^2)^(0.65));
%     Cf_seed = Cf*1.2300123; % TODO
    Cf_seed = 0.0026*Cf/round(Cf,6);
    K = 1/(pi*(1/(pi*K_seed*AR_seed))*AR);

    % >>>> DELTA WEIGHTS <<<<
    DeltaWFuse = WFuse_unit*(lFuse_seed-lFuse);
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

