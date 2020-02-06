% main runner Written by Weizhuo Wang for AE442 Nov 2019
% ==================Inits==================
clc,clear;
addpath(genpath('.'))
format shortG
% ==================Inputs==================
tmp_folder = 'C:\tempSolver\'; % Change this to any folder on your drive, PLEASE use non-OneDrive location
% tmp_folder = '/Users/askker/tmp_folder/'
delete([tmp_folder,'*.mat'])
[fnInputs,fnIter] = deal('inputs.mat','iter.mat');
% guessmat = [77000,100000,0];
guessmat = [98000,263071,0];

ARlist = [5:0.1:11];
AWinglist = [3500:100:9000];

% ==================Solve==================
% solve for current input
tic;[Soln_total] = hw7_solve_contour(ARlist,AWinglist,guessmat,fnInputs,fnIter,false,tmp_folder);tm = toc;
fprintf('Speed: %6.1f cases/sec\n',[length(ARlist)*length(AWinglist)/tm])

% load soln (if you want to see an example of all the input and outputs)
load([tmp_folder,'101iter.mat'])

%% Plot result
zlab = ["MRW (lb)","Fuel Weight (lb)","Empty Weight (lb)"];
figure(1);clf
% sgtitle('Fuselage Length = 42m')
% sgtitle('T/W IPPS = 2.0')
% sgtitle('SFC = 0.8 lb/(lb-hr)')
sgtitle('Default Case')

for i = 1:3        % Plot 2D dimensional diagram
    plot_Soln = Soln_total(:,:,i);
%     threshold = nanmedian(nanmedian(Soln_total(:,:,i)))*1.5;
    threshold = min(Soln_total(:,:,i),[],'all')*1.3;
    plot_Soln(Soln_total(:,:,i)>threshold) = NaN;
    
    % plot 2d contour
    subaxis(2,3,i)
    [X,Y] = meshgrid(ARlist,AWinglist);
    contourf(X,Y,plot_Soln,'ShowText','on');grid on;
    xlabel('AR');ylabel('Wing Area (sq ft)');title(zlab(i))
    colorbar
end

for i = 1:3       % Plot 3D dimensional diagram
    plot_Soln = Soln_total(:,:,i);
%     threshold = nanmedian(nanmedian(Soln_total(:,:,i)))*1.5;
    threshold = min(Soln_total(:,:,i),[],'all')*1.3;
    plot_Soln(Soln_total(:,:,i)>threshold) = NaN;
    
    % plot 3D surface plot
    subaxis(2,3,i+3)
    plot3Dsurf(X,Y,plot_Soln,zlab(i))
end

%% Save plots
% saveas(gcf,'plots\SFC0.8.png')

%% ============Helper Functions===============

function plot3Dsurf(X,Y,plot_Soln,zlab)

    surf(X,Y,plot_Soln);hold on;grid on
    xlabel('AR');ylabel('Wing Area (sq ft)');zlabel(zlab)
    shading faceted
    colormap jet
    view(-45,10) % 0,90 2D plot | yaw,vert
    colorbar
    
end

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
