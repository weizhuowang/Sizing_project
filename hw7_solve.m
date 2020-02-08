function [convergence,soln] = hw7_solve(guessmat,vars,fnInputs,fnIter,plotflg,G450)
% % This file has all the iterative equations used to solve.

    % Generate input parameters accordingly
    if G450
        geninputs_G450(fnInputs,vars);
    else
%         geninputs_787cal(fnInputs,vars,guessmat);
        geninputs_test(fnInputs,vars,guessmat);
%         geninputs_AIAA(fnInputs,vars); % change this according to aircraft
    end
    logmat   = [];
    load(fnInputs);
    
    % Repeat 25 steps to get converged result
    for i = 1:50
%         [FN_calc,WFuel_calc,DeltaWeight_calc] = hw7_iterFun(fnInputs,fnIter,guessmat);
        
        
        
        
        FN_guess = guessmat(1);
        WFuel_guess = guessmat(2);
        DeltaWeight_guess = guessmat(3);
        % =============Calculated===============
        % (Stuff that could change in iterations)

        % >>>> Setup <<<<
        WEmpty = WEmpty_seed + DeltaWeight_guess;  % lb
        MRW    = WFuel_guess + WPayload + WEmpty; % lb MAX Ramp Weight
        MZFW   = WEmpty+MWPayload; % lb Max Zero Fuel Weight
        MLDW   = 0.875*MRW; % lb Max Landing Weight 
        % >>>> Wing <<<<
        WWingSTR   = (4.22*AWing) + (1.642e-6*Nz*span^3*sqrt(MRW*MZFW)*(1+2*taper))/(TC_avg*cosd(EASweep)^2*AWing*(1+taper)); % lb
        WWingStuff = WWingSTR+AWing*1; % lb
        % >>>> Engine <<<<
        Thrust_TO = FN_guess;
        dFan      = 2*sqrt(0.118*Thrust_TO/pi); % in
        dNacel    = dFan+24; % in
        W_IPPS = Thrust_TO/TW_IPPS;
        % >>>> WETTED AREA <<<<
        ANacel_wet = Neng*0.89097*((2*pi*(dNacel/24)*(lNacel/12)+pi*(dNacel/24)^2)-pi*(dFan/24)^2);
        Atotal_wet = ANacel_wet + AFuse_wet + AVtail_wet + AHtail_wet + AWing_wet;
        SwetSref   = Atotal_wet/AWing;
        % >>>> DELTA WEIGHTS <<<<
        DeltaWWing = WWingStuff-WWing_seed;
        % >>>> PERFORMANCE <<<<
        WTOC = MRW*WTOCratio;
        Cl = WTOC/AWing/q;
        Cd0  = SwetSref*Cf_seed;
        Cd = Cd0 + K*Cl^2;
        LD = Cl/Cd;

        WReserve = ReserveRatio*(WEmpty + WPayload); % shouldn't that be 0.05*WFuel?
        WFuelUseable = WFuel_guess-WReserve;
        Range_calc = KRange*KTAS*LD/SFC*log(MRW/(WEmpty+WPayload+WReserve));

        Drag_cruise = q*Cd*AWing;
        TOC_Thrust = ROC_TOC/60*WTOC/VTAS+Drag_cruise;
        TOC_Thrust_eng = TOC_Thrust/Neng;
        TO_eqThrust = TOC_Thrust_eng/Thrust_lapse;
        WEngClimb_IPPS = TO_eqThrust/TW_IPPS;

        % moved from DELTA WEIGHTS
        WEngTO_IPPS = FN_guess/TW_IPPS;
        WEng = max(WEngTO_IPPS,WEngClimb_IPPS);
        DeltaWEng = (WEng-WEng_seed)*Neng;
        DeltaWtotal = DeltaWEng + DeltaWWing + DeltaWHtail + DeltaWVtail + DeltaWFuse;

        % bfl
        Wing_Loading_TO = MRW/AWing;
        TW_TO = FN_guess*Neng/MRW;
        BFL_calc = KTO*Wing_Loading_TO/(TW_TO*Clmax*Sigma);

        % landing
        WLTOratio = MLDW/MRW; % take off, land ratio
        Wing_Loading_L = MLDW/AWing;
        TW_L = FN_guess*Neng/MLDW;
        Slanding = Sair + Kland*Wing_Loading_L*1/(Sigma*Clmax_land*Mu);% LFL
        
        MLDW_Frac_calc = MLDW_calc/MRW;
                
        % >>>> Iteration <<<<
        FN_calc = FN_guess*BFL_calc/BFL_req; % wrong order
        WFuel_calc = range_req/Range_calc*WFuelUseable + WReserve;
        DeltaWeight_calc = DeltaWtotal;
        
        
        
        guessmat = [FN_calc,WFuel_calc,DeltaWeight_calc];
        logmat(end+1,:) = guessmat;
        if i>1
            if abs(logmat(end-1,1)-FN_calc) < 0.1
                break
            end
        end
    end
    
    save(fnIter);
    
    if plotflg
        for i = 1:3
            subplot(3,1,i)
            plot(1:size(logmat,1),logmat(:,i)');grid on;hold on;
        end
    end
    if size(logmat,1) > 1
        convergence = logmat(end,:)-logmat(end-1,:);
    else
        convergence = 0;
    end
    soln = guessmat;
  
end

