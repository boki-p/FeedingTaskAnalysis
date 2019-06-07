% Left panel hand trajectory, right panel resultant velocity


% not gonna play the whole thing
TIME_RATIO = 1;
% Play every other frame to set video speed to 2x real speed
indices = 1:2:TIME_RATIO*length(t);

% Recently added, to see if can show markers on the animation too
idx_all = sort([idx_endoftransport; idx_peak; idx_scoopstart; idx_startofreach]);

% figure
% subplot(1,2,1)
% plot(pos_matrix(indices,1),pos_matrix(indices,2))
% subplot(1,2,2)
% plot(t(indices),v_filtered(indices))

%% Make animation or simply just show the trajectories to visualize

f = figure;
f.Position = [360.3333 197.6667 560*1.5 210*1.5];

% Left panel hand trajectory, right panel resultant velocity
% Using animated lines in different colors

x_task = pos_matrix(:,1);
y_task = pos_matrix(:,2);
z_task = pos_matrix(:,3);
t_vel = t(:);
v_vel = v_filtered(:);

% Set limits before the loop to avoid re-calculating 
sub1 = subplot(2,2,1);
axis([-0.4 0.22 -0.06 0.2])
% axis([-0.4 0.22 -0.06 0.2 -0.5 0.5])
sub1.Position = [0.1,0.2,0.35,0.60];
sub1.Color = 'none';
sub1.XColor = 'none';
sub1.YColor = 'none';
title(sub1,'Hand Trajectory');
a_task = animatedline('Color','black','LineWidth',2);
hold on 
plot1 = plot(0, 0, '*', 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'b');

sub2 = subplot(2,2,2);
axis([0 t(end) -1.5 0.8]);
sub2.Position = [0.5,0.2,0.48,0.60];
sub2.Color = 'none';
%sub2.XColor = 'none';
sub2.YColor = 'none';
title(sub2,'Velocity Profile')
a_vel = animatedline('Color','black','LineWidth',2);
hold on
plot2 = plot(0, 0, '*', 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'b');

%sub3 = subplot(2, 2, 4);

cnt = 0;

count = 1;

for k = 1:length(indices)
    % first line
    xk = x_task(indices(k));
    yk = y_task(indices(k));
    zk = z_task(indices(k));
    addpoints(a_task,xk,yk);
    %addpoints(a_task,xk,yk,zk);
    % second line
    tk = t(indices(k));
    vk = v_vel(indices(k));
    addpoints(a_vel,tk,vk);
    
    % check if this is frame has marker
    % Increased the time window so it's easier for eyes to follow 
    if (indices(k) - idx_all(count) <= 8) & (indices(k) - idx_all(count) >= -4)
         % Then on top of the animation, plot the dots on there 
        plot1.XData = xk; 
        plot1.YData = yk; 
        % second line
        plot2.XData = tk;
        plot2.YData = vk;
        % then move to the next 
        count = count + 1;
        % when count is oversize, reset to 1
        if count == n_reps * 4 + 1
            count = 1;
        end
    end

    % update screen
    drawnow 
    
%{ ---------- STRAIGHT TO GIF -------------
% %    Capture the plot as an image 
%     frame = getframe(f); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
%     % Write to the GIF File 
%     if k == 1 
%     imwrite(imind,cm,'feed1.gif','gif', 'Loopcount',inf, 'DelayTime',0.01);
%     cnt = cnt + 1;
%     elseif cnt == 10
%             imwrite(imind,cm,'feed1.gif','gif','WriteMode','append','DelayTime',0.01); 
%             cnt = 0; 
%     else
%         cnt = cnt + 1;
%     end
% %         
%} -----------
     
    % ---------- Save in frames to be used in .avi------------
    %M(k) = getframe(gcf);
end 

saveas(f,filename(1:end-4),'jpeg')

%%  
% v = VideoWriter('feedingtask_4xspeed.avi');
% % Make the video 2x real speed
% % Set back to sampling frequency because I took every other frame in raw data 
% v.FrameRate = 100;  
% open(v)
% writeVideo(v,M)
% close(v)

