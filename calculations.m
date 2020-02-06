clc,clear;
% calculations
Wpayload = (350+50+2+8)*(200+30)+40000

v = 145*1.852/3.6
AWing = 427;
Clmax = 1.7
LiftMax = 0.5*1.225*v^2*AWing*Clmax
MLW = LiftMax/9.81/1000

% Seed 787-10
AWing = 3501;
sweep = 32.2
taper = 0.149
TW_IPPS = 62500*2/35471


% Seed 777-200
AWing = 4605;
sweep = 31.6
taper = 0.149


% https://booksite.elsevier.com/9780340741528/appendices/data-a/table-4/table.htm
% http://www.lissys.demon.co.uk/samp1/index.html