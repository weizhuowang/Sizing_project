% Process Figures
clc,clear;close all;
cd('..\Trade Study\')
fname = '777_MachvsAlt';
tmp_fig = openfig([fname,'.fig'],'invisible')
figure(tmp_fig)
set(gcf, 'Position',  [100, 100, 2000, 1400])
delete(subplot(2,3,1))
delete(subplot(2,3,4))
sgtitle('')

saveas(tmp_fig,[fname,'.png'])

img = imread([fname,'.png']);

figure(2);
imshow(img)

img = imcrop(img,[1057.5 105.5 1793 1415]);

figure(2);
imshow(img)
imwrite(img,[fname,'.png'])
close all;