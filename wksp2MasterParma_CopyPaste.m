%{
    wksp2MasterParma_CopyPaste.m
    02/08/2020
    C. Rovin

    Script to take the workspace (populated after running main_single.m)
    and create an excel document that is ordered identically to the 
    formatting of MasterParamFile.xlsx.

    To Use:
         1) Run "wksp2MasterParma_CopyPaste" after running main_single.m.
            Alternatively can copy "wksp2MasterParma_CopyPaste" into
            main_single.m at the bottom.
         2) Open the parameter excel document created by this script
         (named:*datetime*_Params.xlsx)
         3) Copy/Paste the variables into MasterParamFile.xlsx

%}
%% Parameters not currently in sizing script
W_WING_GROUP_EST    = 53342.79867;%(lb)
W_GEAR_GROUP_EST    = 25296.85444;%(lb)
W_EMP_GROUP_EST     = 10496.9256;%(lb)
W_PP_GROUP_EST      = 32968.88239;%(lb)
W_FUSE_GROUP_EST    = 43675.37243;%(lb)
W_FIXEQP_GROUP_EST  = 50565.74693;%(lb)
W_NAC_GROUP_EST     = 4888.47861;%(lb)
W_MZFW_EST          = 420598.9716;%(lb)
WING_MAX_THICKNESS  = .12;%(x/100) Percent Root Chord
WING_MAX_T_POS      = .37;%(x/100) Percent Root Chord
WING_AIRFOIL        = 'SC-0412';% Airfoil Name
HTAIL_CR            = 19.52;%(ft)
HTAIL_CT            = 5.77;%(ft)
HTAIL_TAPER         = .3;%(--)
HTAIL_MAX_T_CR      = 2.375;%(in) Max thickness at root
HTAIL_SPAN          = 62.56;%(ft)
HTAIL_SWEEP         = 30;%(deg)
HTAIL_AR            = 5;%(--)
HTAIL_AIRFOIL       = 'NACA0012';% Airfoil Name
VTAIL_CR            = 22.18;%(ft)
VTAIL_CT            = 6.88;%(ft)
VTAIL_TAPER         = .31;%(--)
VTAIL_MAX_T_CR      = 1.875;%(in) Max thickness at root
VTAIL_SPAN          = 24.7;%(ft)
VTAIL_SWEEP         = 35;%(deg)
VTAIL_AR            = 1.7;%(--)
VTAIL_AIRFOIL       = 'NACA0012';% Airfoil Name
ENGINE_NAME         = 'TBD';
ENGINE_WEIGHT       = 'TBD';%(lb)
ENGINE_P2           = 'TBD';%(psi) Static Pressure Entering Compressor
JETFUEL_DENSITY     = 6.02;%(lb/gal)
APU_NAME            = 'TBD';
APU_WEIGHT          = 'TBD';%(lb)
APU_MAX_DIAMETER    = 'TBD';%(in)
APU_MAX_LENGHT      = 'TBD';%(in)
Y_WING              = 'TBD';%(in) Distance of wing (center of root chord) to front of fuselage
Y_VTAIL             = 'TBD';%(in) Distance of vtail (center of root chord) to front of fuselage
Y_HTAIL             = 'TBD';%(in) Distance of htail (center of root chord) to front of fuselage
A_RUDDER            = 'TBD';%(ft^2) Area Rudder
P_D_PSI             = 'TBD';%(psi) Design Dive Dynamic Pressure
V_D_KEAS            = 'TBD';%(keas) Design Dive Speed
GEAR_HEIGHT         = 22.39;%(ft)
Y_GEAR_NOSE         = 20.00;%(ft) Distance frome nose to front gear
Y_GEAR_REAR         = 111.00;%(ft) Distance frome nose to rear gear
X_GEAR_REAR         = 16.79;%(ft) Gear Span
V_PAX_CABIN         = 2800;%(ft^3) Volume Pax Cabin
Z_PAX_CABIN         = 6.5;%(ft) Max Height Pax Cabin
RANGE               = range_req;%(nmi)
PAX                 = 400;%(--)
CREW                = 10;%(--)
PAX_SEATS           = 400;%(--)
CREW_SEATS_MAIN     = 10;%(--) Crew seats in main cabin
CREW_SEATS_CP       = 3;%(--) Crew seats in cockpit (including jump seat)
P_CABIN_CRUISE      = 5.16;%(psi) pressure in main cabin at cruise alt.
V_CARGO             = 650;%(ft^3) total volume cargo holde
V_FUEL              = 2600;%(ft^3) total volume fuel tanks
WING_TWIST          = -3;%(deg) geometric twist
HTAIL_INC_ANG       = 0;%(deg)  Htail Incidence Angle         
HTAIL_R             = 96.98;%(ft) Htail moment arm            
VTAIL_R             = 92.58;%(ft) Vtail moment arm            
ELV_MAC             = 5.49;%(ft) Elevator MAC            
ELV_SPAN            = 56.3;%(ft) Elevator Span         
ELV_ANG             = 30;%(deg) Elevator deflection angle +/-   
RDDR_MAC            = 6.35;%(ft) Rudder MAC           
RDDR_SPAN           = 22.23;%(ft) Rudder Span              
RDDR_ANG            = 30;%(deg) Rudder deflection angle +/-               
AILER_MAC           = 5.24;%(ft) Aileron MAC                  
AILER_SPAN          = 74.42; %(ft) Aileron Span            
AILER_ANG           = 30; %(deg) Aileron deflection angle +/-   
MAIN_DECK_HEIGHT    = 180;%(in) Height of main deck from bottom of fuselage
LWR_DECK_HEIGHT     = 116;%(in) Height of lower deck from bottom of fuselage
HTAIL_VOL_COEF      = .87;%(--) Htail volume coefficient 
VTAIL_VOL_COEF      = .05;%(--) Vtail volume coefficient 
HTAIL_MAC           = 13.72;%(ft) Htail MAC
VTAIL_MAC           = 'TBD';%(ft) Htail MAC

%% Create Column of Parameter Values (doubles)
           
paramCount = 1;
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
% Weights
ParamValues{paramCount,1} = (MRW-3000);          paramCount =  paramCount+1;
ParamValues{paramCount,1} = MRW;                 paramCount =  paramCount+1;
ParamValues{paramCount,1} = MZFW;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = MLDW;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = WFuel_calc;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = WEmpty;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = WPayload;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = WWingStuff;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = WFuse_unit*lFuse;    paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_IPPS;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = WEngClimb_IPPS;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = WEng;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = MWPayload;           paramCount =  paramCount+1;
%Mass Prop Data
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_WING_GROUP_EST;    paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_GEAR_GROUP_EST;    paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_EMP_GROUP_EST;     paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_PP_GROUP_EST;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_FUSE_GROUP_EST;    paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_FIXEQP_GROUP_EST;  paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_NAC_GROUP_EST;     paramCount =  paramCount+1;
ParamValues{paramCount,1} = W_MZFW_EST;          paramCount =  paramCount+1;
%Aero
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = LD;                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = AR;                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = AWing;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = span;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = span_overall;        paramCount =  paramCount+1;
ParamValues{paramCount,1} = sweep;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = taper;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = Cr;                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = MAC;                 paramCount =  paramCount+1;
ParamValues{paramCount,1} = Ct;                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = Clmax_land;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = WING_MAX_THICKNESS;  paramCount =  paramCount+1;
ParamValues{paramCount,1} = WING_MAX_T_POS;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = WING_AIRFOIL;        paramCount =  paramCount+1;
ParamValues{paramCount,1} = WING_TWIST;        paramCount =  paramCount+1;
ParamValues{paramCount,1} = K;        paramCount =  paramCount+1;
ParamValues{paramCount,1} = Cd0;        paramCount =  paramCount+1;
%Fuselage and Tail
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = lFuse;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = dFuse;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = lNose;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = lTail;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_VOL_COEF;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = AHtail;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_CR;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_CT;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_TAPER;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_MAX_T_CR;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_SPAN;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_SWEEP;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_AR;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_MAC;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_AIRFOIL;       paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_VOL_COEF;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = AVtail;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_CR;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_CT;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_TAPER;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_MAX_T_CR;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_SPAN;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_SWEEP;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_AR;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_MAC;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_AIRFOIL;       paramCount =  paramCount+1;
%Propulsion
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = Neng;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = Thrust_TO;           paramCount =  paramCount+1;
ParamValues{paramCount,1} = TW_IPPS;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = WEngTO_IPPS;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = dFan;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = dNacel;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = lNacel;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = TO_eqThrust;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = SFC;                 paramCount =  paramCount+1;
ParamValues{paramCount,1} = ENGINE_NAME;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = ENGINE_WEIGHT;       paramCount =  paramCount+1;
ParamValues{paramCount,1} = ENGINE_P2;           paramCount =  paramCount+1;
ParamValues{paramCount,1} = JETFUEL_DENSITY;     paramCount =  paramCount+1;
ParamValues{paramCount,1} = APU_NAME;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = APU_WEIGHT;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = APU_MAX_DIAMETER;    paramCount =  paramCount+1;
ParamValues{paramCount,1} = APU_MAX_LENGHT;      paramCount =  paramCount+1;
%Structures
ParamValues{paramCount,1} = '' ;                 paramCount =  paramCount+1;
ParamValues{paramCount,1} = Nz;                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = TC_avg;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = sweep;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = WWingSTR;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = WWingStuff;          paramCount =  paramCount+1;
%Wetted Area
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = AWing_wet;           paramCount =  paramCount+1;
ParamValues{paramCount,1} = AHtail_wet;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = AVtail_wet;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = rNose;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = hNose;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = ogive_Rn;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ogive_Dn;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ANose_ogive;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = ABarrel;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = rTail;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = hTail;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = ogive_Rt;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ogive_Dt;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ATail_ogive;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = AFuse_wet;           paramCount =  paramCount+1;
ParamValues{paramCount,1} = ANacel_wet;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = Atotal_wet;          paramCount =  paramCount+1;
ParamValues{paramCount,1} = SwetSref;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = Reft;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = Re;                  paramCount =  paramCount+1;
%S&C
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = Y_WING;              paramCount =  paramCount+1;
ParamValues{paramCount,1} = Y_VTAIL;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = Y_HTAIL;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = A_RUDDER;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = P_D_PSI;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = V_D_KEAS;            paramCount =  paramCount+1;

ParamValues{paramCount,1} = HTAIL_INC_ANG;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = HTAIL_R;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = VTAIL_R;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ELV_MAC;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ELV_SPAN;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = ELV_ANG;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = RDDR_MAC;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = RDDR_SPAN;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = RDDR_ANG;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = AILER_MAC;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = AILER_SPAN;            paramCount =  paramCount+1;
ParamValues{paramCount,1} = AILER_ANG;            paramCount =  paramCount+1;
%Perf.
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = Mach;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = Altitude;            paramCount =  paramCount+1;
%Landing Gear
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = GEAR_HEIGHT;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = Y_GEAR_NOSE ;        paramCount =  paramCount+1;
ParamValues{paramCount,1} = Y_GEAR_REAR;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = X_GEAR_REAR;         paramCount =  paramCount+1;
%Misc
ParamValues{paramCount,1} = '';                  paramCount =  paramCount+1;
ParamValues{paramCount,1} = V_PAX_CABIN;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = Z_PAX_CABIN;         paramCount =  paramCount+1;
ParamValues{paramCount,1} = RANGE;               paramCount =  paramCount+1;
ParamValues{paramCount,1} = PAX;                 paramCount =  paramCount+1;
ParamValues{paramCount,1} = CREW;                paramCount =  paramCount+1;
ParamValues{paramCount,1} = PAX_SEATS;           paramCount =  paramCount+1;
ParamValues{paramCount,1} = CREW_SEATS_MAIN;     paramCount =  paramCount+1;
ParamValues{paramCount,1} = CREW_SEATS_CP;       paramCount =  paramCount+1;
ParamValues{paramCount,1} = P_CABIN_CRUISE;      paramCount =  paramCount+1;
ParamValues{paramCount,1} = V_CARGO;             paramCount =  paramCount+1;
ParamValues{paramCount,1} = V_FUEL;              paramCount =  paramCount+1;
ParamValues{ paramCount,1} = MAIN_DECK_HEIGHT;                    paramCount =  paramCount+1;
ParamValues{ paramCount,1} = LWR_DECK_HEIGHT;                    paramCount =  paramCount+1;

% ParamValues{ paramCount,1} = ;                    paramCount =  paramCount+1;
%% Create a Table with the parameters
CopyPasteParams = table(ParamValues) ; 
saveName        = [datestr(datetime),'_params.xlsx'] ; 
saveName        = strrep(saveName,':','') ; 
saveName        = strrep(saveName,' ','-') ; 
%save excel in local directory with the values
%(first row corresponds to 'weights' in master parameter file --> it is
% left blank)
writetable(CopyPasteParams,saveName)