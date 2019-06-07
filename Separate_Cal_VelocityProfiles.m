% Velocity Profile Overlay
% Also has some plots
close all
clear all
filename = '4214_44_FU_L2.mat';
temp = open(filename);
subdata = temp.subdata;

%% get vel profiles for each rep
fc = 8;

vel_matrix = subdata.vel_matrix;
idx_startofreach = subdata.idx_startofreach;
idx_endoftransport = subdata.idx_endoftransport;
n_reps = length(subdata.TrialTime);

% calculate resultant velocity again
v_vec = sqrt( vel_matrix(:,1).*vel_matrix(:,1)...
    + vel_matrix(:,2).*vel_matrix(:,2) + vel_matrix(:,3).*vel_matrix(:,3) );
sign_vec = vel_matrix(:,2)./abs( vel_matrix(:,2) );
v_res = v_vec.*sign_vec;

v_res = ApplyFilter(v_res, fc);

[v_profiles, t_normed] = TimeNormalization(v_res, idx_startofreach, idx_endoftransport, n_reps);

% Calculate ensemble average of velocity profiles 
v_avg = mean(v_profiles, 1);
v_std = std(v_profiles, 1);

figure
plot(t_normed,v_profiles)
ylabel('velocity')
xlabel('normalized time (100% cycle)')
title('velocity profiles after interpolation')
hold on
% plot out average velocity profile using downloaded package [boundedline]
% by kakearney
% 95% C.I. 
[hl, hp] = boundedline(t_normed, v_avg, 1.96*v_std, 'alpha');
set(hl, 'linewidth', 2, 'color','black');
axis tight;

outfilename = filename;
subdata.v_res = v_res;
subdata.v_profiles = v_profiles;
subdata.t_normed = t_normed;
subdata.v_avg = v_avg;
subdata.v_std = v_std;
save(outfilename,'subdata')
filename