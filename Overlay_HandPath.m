% Create overlay handpath graphs
% First start with Ss with most and lease retention, see if there's
% qualitative difference in there
% Only left hand for now
% 1.20.2019 Ss large retention L:37 38; 
% Ss with small retention L: 36, 39;

% -------------- Start -------------

% Ss 38 Only
% read in NP and FU data
NP = open('4214_31_NP_L2.mat');
FU = open('4214_31_FU_L2.mat');

x_NP = NP.subdata.pos_matrix(:,1);
y_NP = NP.subdata.pos_matrix(:,2);
z_NP = NP.subdata.pos_matrix(:,3);

x_FU = FU.subdata.pos_matrix(:,1);
y_FU = FU.subdata.pos_matrix(:,2);
z_FU = FU.subdata.pos_matrix(:,3);

%% Four plots. x vs y; y vs z
% Use 3D plots instead of 2D to have a better understanding
% Lock axis range for all Ss. axis([-0.4 0.15 -0.1 0.25 0 0.25]);
close all
f = figure;
f.Position = [10 10 900 800];

sub1 = subplot(2,2,1)
plot1_NP = plot3(x_NP, y_NP, z_NP, 'Color','black','LineWidth',2)
hold on
plot1_FU = plot3(x_FU, y_FU, z_FU, '--', 'Color','red','LineWidth',2)
axis tight
grid on
view([0, 90]);  % azimuth - 0, elevation - 90. This is Top view
title('Y vs X plot (Top View)');
axis([-0.4 0.15 -0.1 0.25 0 0.25]);

% do a overall 3D plot 
sub4 = subplot(2,2,2)
plot4_NP = plot3(x_NP, y_NP, z_NP, 'Color','black','LineWidth',2)
hold on
plot4_FU = plot3(x_FU, y_FU, z_FU, '--', 'Color','red','LineWidth',2)
title('Ss 31');
axis tight
grid on
view([40, 45]);
legend('NP','FU','location','northeast');
axis([-0.4 0.15 -0.1 0.25 0 0.25]);

sub3 = subplot(2,2,3)
plot3_NP = plot3(x_NP, y_NP, z_NP, 'Color','black','LineWidth',2)
hold on
plot3_FU = plot3(x_FU, y_FU, z_FU, '--', 'Color','red','LineWidth',2)
axis tight
grid on
view([0, 0]);
title('Z vs X plot (Back View)'); % azimuth - 0, elevation - 0. This is back view
axis([-0.4 0.15 -0.1 0.25 0 0.25]);

sub2 = subplot(2,2,4)
plot2_NP = plot3(x_NP, y_NP, z_NP, 'Color','black','LineWidth',2)
hold on
plot2_FU = plot3(x_FU, y_FU, z_FU, '--', 'Color','red','LineWidth',2)
title('Ss 39');
axis tight
grid on
view([90, 0]);
title('Z vs Y plot (Right View)'); % azimuth - 90, elevation - 0. This is right view
axis([-0.4 0.15 -0.1 0.25 0 0.25]);
