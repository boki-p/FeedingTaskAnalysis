% ------------- Kinematic Data Processing for feeding task -------- 
% Boki
% November 2018
% -----------------------
% Read in data files from .exp file from the Motion Monitor
% The .exp file has to follow this format
% columns -- 'Frame #'  'SpoonX'  'SpoonY'  'SpoonZ'  'v_x'  'v_y'  'v_z'  'a_x'  'a_y'  'a_z'
% .............. How to .............. 
%{ 
INPUTS:
%   In the dialogue window, select "all files"
%   Select the right .exp file
%   Under the TO-DO section, change the values of the following variables
%       according to the .exp file:
%       start_path, filename, subid, session, hand, trial
%   Then execute the whole file. If
%       1) There's error, try increase grace_d
%       2) Program runs through, double check figures and output
% OUTPUT:
%   In variable window, copy and paste the "vars" variable into excel
%   sheet.
% .............. end ..................
%}
%% Prepare to read in data
clear all 
close all

% *************** TO-DO *********************
% CHANGE THESE INPUTS
start_path = 'D:\PractiseDirectory\FeedingTaskAnalysis\tDCS_P02';
%filename = uigetfile(start_path);
filename = 'tDCS_P02_FU0002.exp';
subid = 'tDCS_P02';  % '4214_xx'
session = 'FU';     % 'NP' or 'FU'
hand = 'L';         % 'L' or 'R'
trial = 2;          % number

% ---- If there's an error in the code, increase grace_d
% Change grace_d to identify 15-16 boundaries when spoon is leaving cup
% Change by .005
grace_d = 0.035; % included to account for cups moving from the origin. 

% ---- If the last end of transport doesn't seem right, change grace_span
% grace_span is defaulted at 1, meaning that the maximum time difference
% between last transport end and start should be less than or equal to the 
% maximum difference in the earier 14 trials. But it might not always be
% true. So check the figure and change the grace_span accordingly. 
% When grace_span is too big, there'll be an error. 
grace_span = 1.0;    %
vel_threshold = 0.03;
% analysis parameters
fc = 8; % cutoff freq
% *************** TO-DO END *********************

% Experimental constancts
F_SAMPLING = 100.251; 
CUP_R = 0.095;

% data are stored in struct format in A 
%   A has data, text data, and colheaders
%   A.colheaders has the varialbe names: 
%   {'Frame #','SpoonX','SpoonY','SpoonZ','v_x','v_y','v_z','a_x','a_y','a_z'}
[A,delimiterOut, headerlinesOut]=importdata(filename);

% get variables
% {'pos_x','pos_y','pos_z','vel_x','vel_y','vel_z','acc_x','acc_y','acc_z',}
raw_data = A.data(:, 2:10);
% filter data
filtered_data = ApplyFilter(raw_data, fc);
% get position, velocity and acceleration data
pos_matrix = filtered_data(:,1:3); % position data from [X Y Z]
vel_matrix = filtered_data(:,4:6); 
acc_matrix = filtered_data(:, 7:9);

% get rid of unwanted variables
clear A raw_data delimiterOut headerlinesOut

%%
% calculate resultant velocity 
% the sign of v_vec depends on the y-velocity. 
v_vec = sqrt( vel_matrix(:,1).*vel_matrix(:,1)...
    + vel_matrix(:,2).*vel_matrix(:,2) + vel_matrix(:,3).*vel_matrix(:,3) );
sign_vec = vel_matrix(:,2)./abs( vel_matrix(:,2) );
v_res = v_vec.*sign_vec;
v_filtered = ApplyFilter(v_res, fc);

dt = 1/F_SAMPLING;
tmax = dt*length(filtered_data(:,1));
t = [0:dt:tmax - dt];

%% Define cup boundary by changing grace_d 
% Logic vector Is_In_HomeCup = [0 0 0 ... 1 1 1 ... 0 0 0],
%   where 1 suggests that the spoon is within the home cup
% Use the x, y position to determine if Is_In_HomeCup

% here uses grace_d
cup_r = (CUP_R + grace_d)/2; % Diameter of cup is 9.5 cm
d_to_homecup = sqrt( pos_matrix(:,1).*pos_matrix(:,1)...
    + pos_matrix(:,2).*pos_matrix(:,2) );
Is_In_HomeCup = ( d_to_homecup < cup_r);
If_Is_Boundary = ~Is_In_HomeCup & [0; Is_In_HomeCup(1:end-1)];

% the frames where spoon hit the boundary
idx_CupBoudary = find(If_Is_Boundary == 1);

%% Find 4 types of marker for each reach; 
% 1) start of reach (idx_startofreach); 2) peak velocity (idx_peak); 
%   3) end of transport(idx_endoftransport); 4) end of reach (idx_endofreach)

% trial start ----------------
% After when the cup boundary is identified,
%   work backwards to find reach start which v <= 0.03m/s
% 1. 1st reach
idx_startofreach = zeros(15,1);
pot_idx = find( v_filtered( 1:idx_CupBoudary(1)) <= .03 );   % all potential indices
idx_startofreach(1) = pot_idx(end);
% 2. All other 14 reaches
for i = 2:15
    pot_idx = find( v_filtered( idx_CupBoudary(i-1):idx_CupBoudary(i) ) <= .03 );   
    idx_startofreach(i) = pot_idx(end) + idx_CupBoudary(i-1) - 1;
end

% End of transport -------------------
% defined as the time of bean drop
% When the y position is maximum.
idx_endoftransport = zeros(15,1);
pk_ypos = zeros(15,1);
% 1. First 14 reaches
for i = 1:14
    [pk_ypos(i), idx_endoftransport(i)] = max(pos_matrix( idx_startofreach(i):idx_startofreach(i+1), 2));
    idx_endoftransport(i) = idx_endoftransport(i) + idx_startofreach(i) - 1;
end
% 2. The last peak (same consideration with peak velocity)
% So figure out the largest start-to-end time, 
% Use the max span to find the last peak in y-pos.
maxspan2 = max(idx_endoftransport - idx_startofreach);
[pk_ypos(15), idx_endoftransport(15)] = max( pos_matrix(idx_startofreach(15): idx_startofreach(15)+ grace_span * maxspan2, 2));
idx_endoftransport(15) = idx_endoftransport(15) + idx_startofreach(15) - 1;


% peak velocity -----------------------
idx_peak = zeros(15,1);
PeakVelocity = zeros(15,1);
for i = 1:15
    [PeakVelocity(i), idx_peak(i)] = max(v_filtered( idx_startofreach(i):idx_endoftransport(i) ));
    idx_peak(i) = idx_peak(i) + idx_startofreach(i) - 1;
end
% old codes commented
% 2. The last peak (during reach, not the largest peak at the end)
% So figure out the largest start-to-peak time, in general
% the movements would be at a similar rate, so limit the search to that.
% maxspan = max(idx_peak - idx_startofreach);
% [PeakVelocity(15), idx_peak(15)] = max( v_filtered(idx_startofreach(15): idx_startofreach(15)+maxspan));
% idx_peak(15) = idx_peak(15) + idx_startofreach(15) - 1;

% End of reach/repetition -----------
% Will only be 14 of these, since no one completed the last trip back home.
% When z velocity first changes sign from negative to positive Is_In_HomeCup 
idx_endofreach = zeros(14,1);
Is_Vz_Neg = ( vel_matrix(:,3) <= 0);
If_Vz_Flips = ~Is_Vz_Neg & [0; Is_Vz_Neg(1:end-1)];
Is_pot_end = If_Vz_Flips & Is_In_HomeCup;
for i = 1:14
    % Use boundary markers here because it's more accurate
    pot_idx = find( Is_pot_end( idx_CupBoudary(i):idx_CupBoudary(i+1) ) == 1 );   
    idx_endofreach(i) = pot_idx(1) + idx_CupBoudary(i) - 1;
end

% End of reach is also the start of a new scoop.
%   Identify the first time the spoon get in the cup 
pot_idx = find( Is_pot_end == 1 );   
idx_firsttimeincup = pot_idx(1);
idx_scoopstart = [idx_firsttimeincup; idx_endofreach];

% Plot out to check
close all
figure 
subplot(3,1,1)
plot(t, v_filtered)
hold on
plot(t, Is_In_HomeCup)
ylim([-1.5 1.5])
plot(t(idx_startofreach), v_filtered(idx_startofreach), '>', 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'b')
plot(t(idx_peak), PeakVelocity, '*', 'color','black')
plot(t(idx_endoftransport), v_filtered(idx_endoftransport), 's','MarkerFaceColor','m', 'MarkerEdgeColor', 'b')
plot(t(idx_scoopstart),v_filtered(idx_scoopstart), '<', 'MarkerFaceColor','y', 'MarkerEdgeColor', 'b')
title('Markers')
legend('velocity profile', 'Is\_In\_HomeCup', ...
    'Start of reach', 'Peak Velocity',  ...
    'End of transport','Start of a new scoop','Location','southeastoutside')
subplot(3,1,2)
plot(t, pos_matrix(:,2))
hold on
plot(t(idx_peak), pos_matrix(idx_peak,2), '*', 'color','black')
plot(t(idx_endoftransport), pos_matrix(idx_endoftransport,2), 's','MarkerFaceColor','m', 'MarkerEdgeColor', 'b')
plot(t(idx_scoopstart),pos_matrix(idx_scoopstart,2), '<', 'MarkerFaceColor','y', 'MarkerEdgeColor', 'b')
ylim([-1.5 1.5])
title('Y pos vs time')
legend('y position','Peak Velocity', 'End of Transport',...
    'Start of a new scoop','Location','southeastoutside')
subplot(3,1,3)
plot(t, vel_matrix(:,3))
hold on
plot(t(idx_scoopstart),vel_matrix(idx_scoopstart,3), '<', 'MarkerFaceColor','y', 'MarkerEdgeColor', 'b')
ylim([-1.5 1.5])
title('Z vel vs time')
legend('z velocity', 'Start of a new scoop', ...
    'Location','southeastoutside')

%% Calculate dependent variables for each reach, and trial time
% Inter reah interval; accumulative distance within cup; transport time

% Transport time
TransportTime =  idx_endoftransport - idx_startofreach;
TransportTime = TransportTime * dt;

% Accumulative distance within cup and IRI
%   t from start of scooping to start of reach
DistanceInCup = zeros(15,1);
DwellTime = zeros(15,1);

for i = 1:15
    temp_posmatrix = pos_matrix( idx_scoopstart(i):idx_startofreach(i) ,:);
    d = 0; % accumulative distance for the ith reach
    for j = 1:length(temp_posmatrix) - 1
        d = d + sqrt( (temp_posmatrix(j+1,1) - temp_posmatrix(j,1) )^2 + ... % dx^2
            (temp_posmatrix(j+1,2) - temp_posmatrix(j,2) )^2 + ...           % dy^2
            (temp_posmatrix(j+1,3) - temp_posmatrix(j,3) )^2);             % dz^2
    end
    DistanceInCup(i) = d;
    DwellTime(i) = (idx_startofreach(i) - idx_scoopstart(i)) * dt;
end


% Define trial start as the first time subject start to scoop the bean from the home cup
%   and trial end as the last time beans are dropped from the spoon
TrialTime = zeros(15,1);
TrialTime(:) = (idx_endofreach(end) - idx_scoopstart(1)) * dt; % in seconds

%% Organize variables in table form 
% make sure this is the same format as in the excel sheet
SubID = strings(15,1);
Session = strings(15,1);
Hand = strings(15,1);
Trial = strings(15,1);

SubID(:) = subid;
Session(:) = session;
Hand(:) = hand;
Trial(:) = trial;
Reach = [1:15]';

vars = table(SubID, Session, Hand, Trial, TrialTime, ...        % repetetive info
    Reach, DwellTime, TransportTime, DistanceInCup, PeakVelocity)  % individual reach info

