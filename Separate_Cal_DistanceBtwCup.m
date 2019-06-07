% follow up analysis
% calculate distance between cups. working. 
% Add the new measures to kinematic data.
clear all
filename = '4214_43_NP_R1.mat';
load(filename);

n_reps = length(subdata.TrialTime);
pos_matrix = subdata.pos_matrix;
idx_startofreach = subdata.idx_startofreach;
idx_endoftransport = subdata.idx_endoftransport;
% Accumulative distance between home cup and target cups 
%   t from start of scooping to start of reach
DistanceBtwCup = zeros(n_reps,1);

for i = 1:n_reps
    temp_posmatrix = pos_matrix( idx_startofreach(i):idx_endoftransport(i),:);
    d = 0; % accumulative distance for the ith reach
    for j = 1:length(temp_posmatrix) - 1
        d = d + sqrt( (temp_posmatrix(j+1,1) - temp_posmatrix(j,1) )^2 + ... % dx^2
            (temp_posmatrix(j+1,2) - temp_posmatrix(j,2) )^2 + ...           % dy^2
            (temp_posmatrix(j+1,3) - temp_posmatrix(j,3) )^2);             % dz^2
    end
    DistanceBtwCup(i) = d;
end

outfilename = filename;
subdata.DistanceBtwCup = DistanceBtwCup;
save(outfilename,'subdata')
filename
