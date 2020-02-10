function geninputs_G450(fname_inputs,vars)
    % generate vars
    
    % ===============APIs===============
    varscell = num2cell(vars);
    [AR,AWing] = deal(varscell{:});
    % ===============Inputs===============
    % >>>> Requirements <<<<
    range_req = 4350; % nm
    BFL_req   = 5500; % ft
    Sland_req = 3100;
    % >>>> Vars <<<<
        % Iterations
%     AWing = 1000; % sq ft
%     AR    = 6;   % 
        % Setup
    WPayload  = 1800; % lb
    MWPayload = 6000; % lb
    sweep = 27; % quater chord sweep angle deg
    taper = 0.308;
    lFuse  = 960; % in
    dFuse  = 94;  % in
    lNose  = 150; % in
    lTail  = 260; % in
    Neng    = 2;
    TW_IPPS = 3.25;
    lNacel  = 200; % 
    SFC     = 0.72; % lb/(lb-hr)
    Nz       = 4.5; % Ultimate load
    TC_avg   = 0.085; % thickness average
    EASweep  = 25; % Not sure what this is
        % Wetted Area
    wetted = 2.05;
        % Delta Weights
    WFuse_unit = 25;
    Htail_AW_trade = 6;
    Vtail_AW_trade = 5;
        % Performance
    WTOCratio = 0.97; % top of climb weight ratio
    Altitude  = 41000; %TODO: different altitude 
    DISA   = 0;
    Mach   = 0.77;
    ReserveRatio = 0.05;
    KRange  = 0.95;
    ROC_TOC = 300; % fpm
    Thrust_lapse = 0.175;
    KTO   = 38;
    Clmax = 1.45;
    Clmax_land = 1.6; % landing
    Kland = 20;
    Mu    = 0.45;
    Sigma = 1;
    % >>>> Seed Input <<<<
    WEmpty_seed  = 43000; % lb
    K_seed       = 0.06;
    AR_seed      = 5.91891092;
    WWing_seed   = 8471.91358;
    lFuse_seed   = 960;
    AHtail_seed  = 237.5859375;%0.25*AWing;
    AVtail_seed  = 118.7929688;%0.125*AWing;
    Thrust_seed  = 13850;
    TW_IPPS_seed = 2.75;
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

    Re   = 5.58406e-4*VTAS*Cr/(2.97319e-7)/12;
    Reft = Re/Cr*12;
    Cf   = 0.455/(log10(Re)^(2.58)*(1+0.144*Mach^2)^(0.65));
    Cf_seed      = Cf*1.2300123; % TODO
    K = 1/(pi*(1/(pi*K_seed*AR_seed))*AR);

    % >>>> DELTA WEIGHTS <<<<
    DeltaWFuse = WFuse_unit*(lFuse_seed-lFuse);
    DeltaWHtail = -AHtail_seed*Htail_AW_trade+Htail_AW_trade*AHtail;
    DeltaWVtail = -AVtail_seed*Vtail_AW_trade+Vtail_AW_trade*AVtail;

    % >>>> PERFORMANCE <<<<
    q = 0.5*1.4*2116.22*0.22336*exp((36089-Altitude)/20806.7)*Mach^2;
        % landing
    Sair = (50-15)/tand(3)+(15-0)/tand(1.5); % Landing Air Distance
    MLDW_calc = ((Sland_req-Sair)/Kland)*AWing*Mu*Sigma*Clmax_land;
    MLDW_WingLoad_calc = MLDW_calc/AWing;
    
    % =============Save content=================
    save(fname_inputs);
end