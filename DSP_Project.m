clear all; clc;

%%Declaration of Variables
L = 50;                                            %Window of Records
f0 = 50;                                            %Hz Nominal Frequency
fs = 2.45e3;                                        %Hz (kilo) Sampling Rate
n = 0:L-1;                                          
RMS = 220;                                          %V Root Mean Square
A = sqrt(2)*RMS;                                    %Amplitude

max = 2*pi;                                       %MaxInterval Phi
min = 0;                                            %MinInterval Phi
phi = min + (max-min).*rand(1, 1);                  %Random Phase
N = 2*fs/f0;                                       %Number of Samples for Coherent Sampling
M = 4.6*fs/f0;                                      %Number of Samples for non Coherent Sampling

x = A * sin(2*pi*f0/fs*n + phi);                    %Input Sequence Coherent
y = A * sin(2*pi*f0/fs*n + phi);                    %Input Sequence Non Coherent
%xX = @(f) (RMS * sqrt(2)) * sin( (2 * pi * f0 * f) / fs );     %SineWave
%x = @(n) (A * sin(2 * pi * f0 / fs * n + phi));
sigmax2 = sqrt(mean(x.^2));


figure;                                          
stem(n,x);                                          %Plot of the Input Signal

X = dft(x, N);
Y = dft(y, M);



%%Coherent Sampling Case
omega_X = [0:N-1]*2*pi/N;
%Spectral Plots 
[mag_X, phase_X, mag_X_dB, phase_X_dB]=printGraph(X, omega_X, N, f0);

%%Non Coherent Sampling Case
omega_Y = [0:M-1]*2*pi/M;
%Spectral Plots 
[mag_Y, phase_Y, mag_Y_dB, phase_Y_dB]=printGraph(Y, omega_Y, M, f0);


SNR = 50;
sz_x = size(x);
sigman2 = 10^(SNR/20);
noise_x = sqrt(sigman2).*randn(sz_x);
figure;
plot(n, noise_x);
A1 = (A / 100) * 10;
HarmI_X = A1 * sin(2*pi*2*f0/fs*n + phi);
HarmII_X = A1 * sin(2*pi*3*f0/fs*n + phi);
sig_corrupted_X = x + noise_x + HarmI_X + HarmII_X;

figure;
plot(n, sig_corrupted_X);

mean_X = mean(sig_corrupted_X);
variance_X = var(sig_corrupted_X);

%sum1 = 0;
%for i=1:length(sig_corrupted_X)
%  sum1 = sum1 + sig_corrupted_X(i);
%end
%M_X = sum1/length(sig_corrupted_X); %the mean
%sum2 = 0;
%for i=1:length(sig_corrupted_X)
%    sum2 = sum2 + (sig_corrupted_X(i)-M_X)^2;
%end
%V_X = sum2/length(sig_corrupted_X); %Varaince




sz_y = size(y);
sigman2 = 10^(SNR/20);
noise_y = sqrt(sigman2).*randn(sz_y);
figure;
plot(n, noise_y);
A1 = (A / 100) * 10;
HarmI_Y = A1 * sin(2*pi*2*f0/fs*n + phi);
HarmII_Y = A1 * sin(2*pi*3*f0/fs*n + phi);
sig_corrupted_Y = y + noise_y + HarmI_Y + HarmII_Y;

figure;
plot(n, sig_corrupted_Y);

media_Y = mean(sig_corrupted_Y);
variance_Y = var(sig_corrupted_Y);



omega_win = 0:N-1 *2*pi/N;

w0 = hanning(N);
w1 = blackman(N);
w2 = kaiser(N, 3);
figure;
plot(1:N,w0,'r',1:N,w1,'b',1:N,w2,'k');






%HANNING
X_han = dft(X.*w0', N);
[X_han_mag, X_han_phase, X_han_mag_dB, X_han_phase_dB] = printGraph(X_han, omega_X, N, f0); 

Y_han = dft(Y.*w0', N);
[Y_han_mag, Y_han_phase, Y_han_mag_dB, Y_han_phase_dB] = printGraph(Y_han, omega_Y, N, f0); 

%BLACKMAN
X_bla = dft(X.*w1', N);
[X_bla_mag, X_bla_phase, X_bla_mag_dB, X_bla_phase_dB] = printGraph(X_bla, omega_X, N, f0); 

Y_bla = dft(Y.*w1', N);
[Y_bla_mag, Y_bla_phase, Y_bla_mag_dB, Y_bla_phase_dB] = printGraph(Y_bla, omega_Y, N, f0); 

%KAISER
X_kai = dft(X.*w2', N);
[X_kai_mag, X_kai_phase, X_kai_mag_dB, X_kai_phase_dB] = printGraph(X_kai, omega_X, N, f0); 

Y_kai = dft(Y.*w2', N);
[Y_kai_mag, Y_kai_phase, Y_kai_mag_dB, Y_kai_phase_dB] = printGraph(Y_kai, omega_Y, N, f0); 

