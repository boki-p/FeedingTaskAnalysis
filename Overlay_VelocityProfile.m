% Overlay average velocity profiles
% NP vs. FU
% Read in saved .mat files
% only left hand
% 1.24.2019  

% -------------- Start -------------
clc;    % Clear the command window.
clear all
close all

has2FU = 1;
t_normed = 0:1:100;

subID = '4214_44';

filename = [subID '_NP_L1.mat'];
temp = open(filename);
NP_v_profiles = temp.subdata.v_profiles;
NP_v_avg = temp.subdata.v_avg;
NP_v_std = temp.subdata.v_std;

% In case there're two NPs. 
% filename = [subID '_NP_L2.mat'];
% temp = open(filename);
% NP_v_profiles = [NP_v_profiles; temp.subdata.v_profiles];
% NP_v_avg = temp.subdata.v_avg;
% NP_v_std = temp.subdata.v_std;

filename = [subID '_FU_L1.mat'];
temp = open(filename);
FU_v_profiles = temp.subdata.v_profiles;

if has2FU
    filename = [subID '_FU_L2.mat'];
    temp = open(filename);
    v_temp = temp.subdata.v_profiles;
    FU_v_profiles = [FU_v_profiles; v_temp];
end

FU_v_avg = mean(FU_v_profiles,1);
FU_v_std = std(FU_v_profiles,1);

f = figure; 
[hl1, hp1] = boundedline(t_normed, NP_v_avg, 1.96*NP_v_std, 'blue','alpha');
set(hl1, 'linewidth', 2);
hold on 
[hl2, hp2] = boundedline(t_normed, FU_v_avg, 1.96*FU_v_std,'red', 'alpha');
set(hl2, 'linewidth', 2);
axis([0 100 -0.2 1]);
legend('NP CI','NP','FU CI', 'FU')
ylabel('Velocity')
xlabel('normalized time (100% cycle)')
title('velocity profiles NP vs FU')

saveas(f,[filename(1:7) '_VProfile'],'jpeg')
