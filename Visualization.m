%%
% Visualization on position profiles
figure 
subplot(4,1,1)
plot(t, v_filtered)
hold on
plot(t, Is_In_HomeCup)
ylim([-1.5 1.5])
plot(t(idx_CupBoudary), v_filtered(idx_CupBoudary),'*')
plot(t(idx_startofreach), v_filtered(idx_startofreach), '*')
plot(t(idx_peak), PeakVelocity, '*', 'color','black')
title('Is\_In\_HomeCup vs time')
legend('velocity profile', 'Is\_In\_HomeCup', ...
    'Cup Boundary','Start', 'Peak','Location','southeast')
subplot(4,1,2)
plot(t, pos_matrix(:,1))
hold on
plot(t(idx_CupBoudary), pos_matrix(idx_CupBoudary,1),'*')
ylim([-1.5 1.5])
title('X pos vs time')
legend('x position', 'Cup Boundary Markers', ...
    'Location','southeast')
subplot(4,1,3)
plot(t, pos_matrix(:,2))
hold on
plot(t(idx_CupBoudary), pos_matrix(idx_CupBoudary,2),'*')
ylim([-1.5 1.5])
title('Y pos vs time')
legend('y position', 'Cup Boundary Markers',...
    'Location','southeast')
subplot(4,1,4)
plot(t, vel_matrix(:,3))
hold on
plot(t(idx_CupBoudary), vel_matrix(idx_CupBoudary,3),'*')
ylim([-1.5 1.5])
title('Z vel vs time')
legend('z vel', 'Cup Boundary Markers', ...
    'Location','southeast')

%%
% See how it matches up to individual velocity profiles
figure 
subplot(4,1,1)
plot(t, v_filtered)
hold on
plot(t, Is_In_HomeCup)
ylim([-1.5 1.5])
plot(t(idx_CupBoudary), v_filtered(idx_CupBoudary),'*')
title('Is\_In\_HomeCup vs time')
legend('velocity profile', 'Is\_In\_HomeCup', ...
    'If\_Exceeds\_Threshold\_In\_Cup','Location','southeast')
subplot(4,1,2)
plot(t, vel_matrix(:,1))
hold on
plot(t(idx_CupBoudary), vel_matrix(idx_CupBoudary,1),'*')
ylim([-1.5 1.5])
title('X vel vs time')
legend('x velocity', 'Cup Boundary Markers', ...
    'Location','southeast')
subplot(4,1,3)
plot(t, vel_matrix(:,2))
hold on
plot(t(idx_CupBoudary), vel_matrix(idx_CupBoudary,2),'*')
ylim([-1.5 1.5])
title('Y vel vs time')
legend('y velocity', 'Cup Boundary Markers', ...
    'Location','southeast')
subplot(4,1,4)
plot(t, vel_matrix(:,3))
hold on
plot(t(idx_CupBoudary), vel_matrix(idx_CupBoudary,3),'*')
ylim([-1.5 1.5])
title('Z vel vs time')
legend('z velocity', 'Cup Boundary Markers', ...
    'Location','southeast')
