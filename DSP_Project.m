clear all; close all; clc;
%% Code developed for the DSP course project:
    % Synchrophasor Estimation
    % By : Donato d'Acunto and Riccardo Maistri
%% Declaration of Variables
L = 161;                                           % Window of Records
f0 = 50;                                           % Hz Nominal Frequency
fs = 2.45e3;                                       % Hz (kilo) Sampling Rate
n = 0:L-1;                                          
RMS = 220;                                         % V Root Mean Square
A = sqrt(2)*RMS;                                   % Amplitude

max = 2*pi;                                        % MaxInterval Phi
min = 0;                                           % MinInterval Phi
phi = min + (max-min).*rand(1, 1);                 % Random Phase
N = 2*fs/f0;                                       % Number of Samples for Coherent Sampling
M = round(2.3*fs/f0)+1;                            %Number of Samples for non Coherent Sampling

x = A * sin(2*pi*f0/fs*n + phi);                   %Input Sequence Coherent
y = A * sin(2*pi*f0/fs*n + phi);                   %Input Sequence Non Coherent

figure;                                          
stem(n,x);                                          %Plot of the Input Signal

%% 1 part
X = dft(x, N);
Y = dft(y, M);
%pks=findpeaks(select,abs(X),'MinPeakHeight',1)
%%Coherent Sampling Case
%TODO :must be on the peaks of th e
omega_X = 0:N-1*2*pi/N;
%Spectral Plots 
[mag_X, phase_X, mag_X_dB, phase_X_dB]=printGraph(X, omega_X, N);
%close all;
%%Non Coherent Sampling Case
omega_Y = 0:M-1*2*pi/M;
%Spectral Plots 
[mag_Y, phase_Y, mag_Y_dB, phase_Y_dB]=printGraph(Y, omega_Y, M);

%% 2 part
SNR = 50;         %TODO variare snr                                              %dB
sz_x = size(x);
%t_n= 0:1/fs:1/f0;
%DONE : correzzione calcolo SNR
%TODO cambiare plot  (DONE)
%sigman2 = 10^(SNR/20);
A1 = (A / 100) * 10;
sigman2 =    A^2*0.5*10^(-SNR/10)*300;  %A^2/
variance = 10^(-SNR/10);

noise_x = sqrt(sigman2).*randn(sz_x); 
figure
plot(noise_x)
% Random Noise
%noise_x = awgn(x,SNR,'measured','db');
a=x+ noise_x;
figure;
plot(x);
hold on;
plot(noise_x);
hold on;
plot(a);

HarmI_X = A1 * sin(2*pi*2*f0/fs*n + phi);               % Harmonic II
HarmII_X = A1 * sin(2*pi*3*f0/fs*n + phi);              % Harmonic III   
sig_corrupted_X = x + noise_x + HarmI_X + HarmII_X;     % Output Signal
total_noise = noise_x + HarmI_X + HarmII_X;             % Total Amount of Noise

% Plots
figure;
plot(noise_x);
figure;
plot(total_noise);
title('Total noise');
figure;
subplot(3,1,1);
plot(n, noise_x);
title('Random Noise');
subplot(3,1,2);
plot(n, HarmI_X);
title('II Harmonic');
subplot(3,1,3);
plot(n, HarmII_X);
title('III Harmonic');

figure;
plot(n, noise_x);
hold on;
plot(n, x);
hold on;
plot(n, HarmI_X);
hold on;
plot(n, HarmII_X);
hold on;
plot(n, sig_corrupted_X);
legend('Random noise','Original signal','II harmonic','III harmonic', 'Corrupted Signal')
ylabel('Voltage [V]');

% Computation of the means and variances
mean_X = mean(total_noise);
variance_X = var(total_noise);
mean_rand = mean(noise_x);
variance_rand = var(noise_x);
mean_harm2 = mean(HarmI_X);
variance_harm2 = var(HarmI_X);
mean_harm3 = mean(HarmII_X);
variance_harm3 = var(HarmII_X);
%close all;
%% Part 3
P = 10;                                        % Parameter Beta to vary
for i=1:1:P                          
    wind_k = kaiser(L, i);                      % Kaiser Window
    x_wind_n = x.*wind_k';                      % Applying Kaiser Window
    figure(49);
    hold on;
    plot(1:L, wind_k);
    xlim([0 161]);
    
    figure(52);
    hold on;
    plot(x_wind_n);
    ylabel('Voltage [V]');
    xlim([0 161]);
    
    X_wind = dft(x.*wind_k', N);
    Y_wind = dft(y.*wind_k', M);
    [mag_x, phi_x, mag_dB_x, phase_dB_x, magf_x, phif_x, mag_dB_f_x] = ...
        printGraph_2(X_wind, N);
    [mag_y, phi_y, mag_dB_y, phase_dB_y, magf_y, phif_y, mag_dB_f_y] = ...
        printGraph_2(Y_wind, M);
    
    figure(50);
    subplot(2,1,1);
    hold on;
    plot(mag_dB_f_x);
    xlim([0 N]);
    ylabel('MAG[ABS(X)] dB');
    subplot(2,1,2);
    hold on;
    plot(phif_x);
    xlim([0 N]);
    ylabel('Phase');
    
    figure(51);
    subplot(2,1,1);
    hold on;
    plot(mag_dB_f_y);
    xlim([0 M]);
    ylabel('MAG[ABS(X)] dB');
    subplot(2,1,2);
    hold on;
    plot(phif_y);
    xlim([0 M]);
    ylabel('Phase');
end

sz_x = size(x);
%sigman2 = 10^(-SNR/20);
%TODO cambiare plot
sigman2 =  A^2*0.5*10^(-SNR/10);
A1 = (A / 100) * 10;

noise_x = sqrt(sigman2).*randn(sz_x);
figure(53);
subplot(5,1,2);
plot(n, noise_x);
xlim([0 L]);
ylabel('Random Noise');
%close all;
%% Part 4
P = 10;
for i=1:1:P
    x_wind_noise = kaiser(L, i);                                            % Kaiser Window
    x_wind_n = x.*x_wind_noise';                                            % Applying Kaiser Window
    HarmI_X_win = A1 * sin(2*pi*2*f0/fs*n + phi).*x_wind_noise';
    HarmII_X_win = A1 * sin(2*pi*3*f0/fs*n + phi).*x_wind_noise';
    %noise_x=0;
    sig_corrupted_X_win = x_wind_n + noise_x + HarmI_X_win + HarmII_X_win;
    %TODO change report cap 7
    % Plots
    figure(53);
    subplot(5,1,1);
    hold on;
    plot(x_wind_n);
    xlim([0 L]);
    ylabel('Original Signal');
    subplot(5,1,3);
    hold on;
    plot(HarmI_X_win);
    xlim([0 L]);
    ylabel('II Harmonic');
    subplot(5,1,4);
    hold on;
    plot(HarmII_X_win);
    xlim([0 L]);
    ylabel('III Harmonic');
    subplot(5,1,5);
    hold on;
    plot(sig_corrupted_X_win);
    xlim([0 L]);
    ylabel('Corrupted Signal');
    
    % 3 Examples
    if i==1
        figure(54);
        
        subplot(5,1,1);
        plot(x_wind_n);
        xlim([0 L]);
        title('Example Kaiser with Beta = 1')
        ylabel('Original Signal');
        subplot(5,1,2);
        plot(n, noise_x);
        xlim([0 L]);
        ylabel('Random Noise');
        subplot(5,1,3);
        plot(HarmI_X_win);
        xlim([0 L]);
        ylabel('II Harmonic');
        subplot(5,1,4);
        plot(HarmII_X_win);
        xlim([0 L]);
        ylabel('III Harmonic');
        subplot(5,1,5);
        plot(sig_corrupted_X_win);
        xlim([0 L]);
        ylabel('Corrupted Signal');
    end
    
    if i==4
        figure(55);
        
        subplot(5,1,1);
        plot(x_wind_n);
        xlim([0 L]);
        title('Example Kaiser with Beta = 4')
        ylabel('Original Signal');
        subplot(5,1,2);
        plot(n, noise_x);
        xlim([0 L]);
        ylabel('Random Noise');
        subplot(5,1,3);
        plot(HarmI_X_win);
        xlim([0 L]);
        ylabel('II Harmonic');
        subplot(5,1,4);
        plot(HarmII_X_win);
        xlim([0 L]);
        ylabel('III Harmonic');
        subplot(5,1,5);
        plot(sig_corrupted_X_win);
        xlim([0 L]);
        ylabel('Corrupted Signal');
    end
    
    if i==8
        figure(56);
        
        subplot(5,1,1);
        plot(x_wind_n);
        xlim([0 L]);
        title('Example Kaiser with Beta = 8')
        ylabel('Original Signal');
        subplot(5,1,2);
        plot(n, noise_x);
        xlim([0 L]);
        ylabel('Random Noise');
        subplot(5,1,3);
        plot(HarmI_X_win);
        xlim([0 L]);
        ylabel('II Harmonic');
        subplot(5,1,4);
        plot(HarmII_X_win);
        xlim([0 L]);
        ylabel('III Harmonic');
        subplot(5,1,5);
        plot(sig_corrupted_X_win);
        xlim([0 L]);
        ylabel('Corrupted Signal');
    end
end