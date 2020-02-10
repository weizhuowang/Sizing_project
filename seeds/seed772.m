function [seedval] = seed772()

    % >>>> Seed Input <<<<
%     TODO: Take seed wing area and calculate wing weight from area
    AWing_seed = 4605;
    WEmpty_seed  = 297300; % lb
    WFuel_seed = 207700;
    AR_seed      = 8.686;
    K_seed       = 1/(pi*0.83*AR_seed);
    Nz_seed      = 3.75;
    EASweep_seed = 31.6;
    TC_avg_seed  = 0.09;
    taper_seed   = 0.149;
        
    % Estimate wing weight
%     WWing_seed = 81384;%60038;
    MRW_seed   = WEmpty_seed + WFuel_seed + 66000; % +3500 lb diff
    MZFW_seed  = WEmpty_seed + 120080;
    span_seed  = sqrt(AWing_seed*AR_seed); % ft
    WWing_seed = (4.22*AWing_seed) + (1.642e-6*Nz_seed*span_seed^3*sqrt(MRW_seed*MZFW_seed)*...
                 (1+2*taper_seed))/(TC_avg_seed*cosd(EASweep_seed)^2*AWing_seed*(1+taper_seed));
    
    lFuse_seed   = 2509;
    AHtail_seed  = 1090;%0.21891*AWing; % TODO: check these ratios in design
    AVtail_seed  = 573;%0.11247*AWing;
    Thrust_seed  = 77200;
    TW_IPPS_seed = 3.72;
%     Cf_seed      = 0.003; % TODO


    seedval = {WWing_seed,lFuse_seed,AHtail_seed,AVtail_seed,Thrust_seed,...
        TW_IPPS_seed,K_seed,AR_seed,WEmpty_seed};

end

