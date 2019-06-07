% meeting with vish to do FFT
% read in NP and FU data
NP = open('4214_40_NP_L1.mat');
FU = open('4214_40_FU_L1.mat');
%
Fs = 100; 
dt = 1/Fs;

px_NP = NP.subdata.pos_matrix(:,1);
px_FU = FU.subdata.pos_matrix(:,1);

t_NP = 0: dt: (length(px_NP) - 1)*dt;
t_FU = 0: dt: (length(px_FU) - 1)*dt;

% FFT on vx
vx_NP_f = abs( fftshift( fft(px_NP) ) );
vx_FU_f = abs( fftshift( fft(px_FU) ) );

f_NP = linspace(-Fs/2, Fs/2, length(px_NP));
f_FU = linspace(-Fs/2, Fs/2, length(px_FU));
% plot
subplot(2,1,1)
plot(t_NP, px_NP)
hold on 
plot(t_FU, px_FU)

subplot(2,1,2)
plot(f_NP, vx_NP_f)
hold on 
plot(f_FU, vx_FU_f)