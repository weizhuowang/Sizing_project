% main runner Written by Weizhuo Wang for AE442 Nov 2019
% ==================Inits==================
clc,clear;
addpath(genpath('.'))
format shortG
% ==================Inputs==================
tmp_folder = 'C:\tempSolver\'; % Change this to any folder on your drive, PLEASE use non-OneDrive location
% tmp_folder = '/Users/askker/tmp_folder/'
delete([tmp_folder,'*'])
[fnInputs,fnIter] = deal([tmp_folder,'inputs.mat'],[tmp_folder,'iter.mat']);
% guessmat = [77000,100000,0];
guessmat = [77200,189071,0];

% ARlist = [5:0.1:11];
% AWinglist = [3500:100:9000];

% ==================Solve==================
% solve for current input
% 777 Cal
% hw7_solve(guessmat,[8.686,4605],fnInputs,fnIter,1,0);
% 787 Cal
% hw7_solve(guessmat,[9.67,3805],fnInputs,fnIter,1,0);
% Our Design
hw7_solve(guessmat,[7.5,3900],fnInputs,fnIter,1,0);

% load soln (if you want to see an example of all the input and outputs)
load([tmp_folder,'iter.mat'])

logmat

%% ============Helper Functions===============

function [Soln_total] = hw7_solve_contour(Xlist,Ylist,guessmat,fnInputs,fnIter,plot,tmp_folder)

    Soln_total = [];
    Soln_total_mrw = [];Soln_total_wfuel = [];Soln_total_wemp = [];
    parfor yid = 1:length(Ylist)
        Soln_mrw = [];Soln_wfuel = [];Soln_wemp = [];
        for xid = 1:length(Xlist)
            fprintf('x = %2.2f | y = %2.2f\n',[Xlist(xid),Ylist(yid)])
            fnip = [tmp_folder,num2str(yid*100+xid),fnInputs];
            fnit = [tmp_folder,num2str(yid*100+xid),fnIter];
            hw7_solve(guessmat,[Xlist(xid),Ylist(yid)],fnip,fnit,plot,0);
            [Soln_mrw(end+1),Soln_wfuel(end+1),Soln_wemp(end+1)] = logdata(fnit);
        end
%         fprintf('%2.2f | ',Soln_mrw);fprintf('\n\n');
        Soln_total_mrw(yid,:) = Soln_mrw;
        Soln_total_wfuel(yid,:) = Soln_wfuel;
        Soln_total_wemp(yid,:) = Soln_wemp;
    end
    Soln_total(:,:,1) = Soln_total_mrw;    
    Soln_total(:,:,2) = Soln_total_wfuel;    
    Soln_total(:,:,3) = Soln_total_wemp;

end

function [MRW,WFuel_calc,WEmpty] = logdata(fnit)

    load(fnit);

end
