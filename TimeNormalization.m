function [v_profile, t_normed] = TimeNormalization(v_res, idx_startofreach, idx_endoftransport, n_reps)
% ------------- Normalize time for kinematic data of different duration-------- 
% Boki
% January 2019
% -----------------------------------------------
% Use cubic spline to interpolate data
%
% Inputs: resultant velocity array; index of start time; index of end time, number
% of repetition
% Output: time-normalized, resampled profile in an array. Each row is the
% velocity file of a repetition
% 
% Defalt 
% --------------- End ---------------------------
    % Perform time normalization to velocity profiles. Store time-normalized
    % data into v_profile
    t_normed = 0:1:100;  % each cycle has 101 points.
    v_profile = zeros(n_reps,length(t_normed));
    for i = 1:n_reps
        vel_profile = v_res(idx_startofreach(i) : idx_endoftransport(i)); % use curly brackets for direct content. smooth brackets for sets.
        l = length(vel_profile);
        t_rep = linspace(0,100,l)'; % individual points

        % Cubic spline interpolation
        v_profile(i,:) = spline(t_rep,vel_profile,t_normed);
    end
end 