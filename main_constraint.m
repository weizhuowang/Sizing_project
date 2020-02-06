% main runner
% need: TW vs WS plot
% Inits
clc,clear;
format shortG
delete('C:\tempSolver\*')
[fnInputs,fnIter] = deal('inputs.mat','iter.mat');
guessmat = [77000,100000,0];

% solve for current input
ARlist = [5:0.25:12];
AWinglist = [2000:500:10000];
[Soln_TO,Soln_L,Soln_C] = hw7_solve_contour(ARlist,AWinglist,guessmat,fnInputs,fnIter,false);

% load soln
load(['C:\tempSolver\101',fnIter])

%%
patchpts_good = [-20  , 87.4 ,213.8 ,235.7 , 235.7 ,-20;
                 0.257, 0.257, 0.62 ,0.6799, 2 , 2];
patchpts_bad = [-20  , 87.4 ,213.8, 235.7 ,  235.7 ,700 ,700, -20;
                0.257, 0.257, 0.62, 0.6799 ,   2   , 2 ,  -2 ,  -2];
figure(1);clf
patch(patchpts_good(1,:),patchpts_good(2,:),'g','FaceAlpha',0.3);hold on;
patch(patchpts_bad(1,:),patchpts_bad(2,:),'r','FaceAlpha',0.3);hold on;
threshold = mean(nanmedian(Soln_TO(:,1)))*2
% Soln_total(Soln_total>threshold) = NaN
useful = Soln_TO(:,1)<threshold*5;
scatter(Soln_TO(useful,1),Soln_TO(useful,2),'filled');grid on;hold on;
scatter(Soln_L(:,1),Soln_L(:,2),'filled');grid on;hold on;
scatter(Soln_C(:,1),Soln_C(:,2),'filled');grid on;hold on;
legend('Valid Design Region','Invalid Design Region','Take Off','Landing','Cruise')
xlabel('W/S (psf)');ylabel('T/W (lb/lb)')
xlim([00,250]);ylim([0.1,1])




%% ============Helper Functions===============

function [Soln_TO,Soln_L,Soln_C] = hw7_solve_contour(Xlist,Ylist,guessmat,fnInputs,fnIter,plot)

    Soln_TO = zeros(length(Xlist)*length(Ylist),2); Soln_L = zeros(length(Xlist)*length(Ylist),2);
    for yid = 1:length(Ylist) % y
        for xid = 1:length(Xlist) % x
            [x,y] = deal(Xlist(xid),Ylist(yid));
            fprintf('x = %5.1f | y = %5.1f\n',[x,y])
            inputvars = [x,y];
            fnip = ['C:\tempSolver\',num2str(yid*100+xid),fnInputs];fnit = ['C:\tempSolver\',num2str(yid*100+xid),fnIter];
            hw7_solve(guessmat,inputvars,fnip,fnit,plot,0);
            idx = (yid-1)*length(Xlist)+xid;
            [Soln_TO(idx,:),Soln_L(idx,:),Soln_C(idx,:)] = logdata(fnit);
        end
%         fprintf('%2.2f | ',Soln_x);fprintf('\n\n');
%         Soln_total(yid,:) = Soln_x;
    end

end

function [TO,L,C] = logdata(fnit)

    load(fnit);
%     retvar = FN_calc;
    TO = [Wing_Loading_TO,TW_TO];
    
    WS_L = (Sland_req-Sair)/80*Sigma*Clmax_land;
    L = [WS_L,TW_L];
    WS_C = (MZFW+0*WFuel_calc)/AWing;
    TW_C = 0.267*Mach^(0.363);
    C = [WS_C,TW_C];
    
end
