clear all; clc;

%%Declaration of Variables
L = 200;                                            %Window of Records
f0 = 50;                                            %Hz Nominal Frequency
fs = 2.45e3;                                        %Hz (kilo) Sampling Rate
n = 0:L-1;                                          
RMS = 220;                                          %V Root Mean Square
A = sqrt(2)*RMS;                                    %Amplitude

max = 2*pi;                                         %MaxInterval Phi
min = 0;                                            %MinInterval Phi
phi = min + (max-min).*rand(1, 1);                  %Random Phase
N = 3.7*fs/f0;                                          %Number of Samples

x = A * sin(2*pi*f0/fs*n + phi);                    %Input Sequence
%xX = @(f) (RMS * sqrt(2)) * sin( (2 * pi * f0 * f) / fs );     %SineWave
%x = @(n) (A * sin(2 * pi * f0 / fs * n + phi));
sigmax2 = sqrt(mean(x.^2));


figure(1);                                          
stem(n,x);                                          %Plot of the Input Signal


%%Performs the DFT of the sequence
j = complex(0, 1);
L1 = length(x);

if N < L1
    disp('warning: time aliasing may occur in case of inverse transformation');    
    x_e=x(1:N);
elseif N>L1
    x_e=x;
    for n=(L1+1):N
        % zero padding
        x_e(n)=0;
    end; 
else    
    x_e=x;
end; 

n=0:length(x_e)-1;
k=0:N-1;
V = exp(-j*2*pi/N*n'*k);                            %Matrix of twiddle factors
X = x_e*V;                                          %The DTFT (matrix product)
omega = [0:N-1]*2*pi/N;

figure;
stem(n, X);
zoom xon;


%Spectral Plots 
figure(3);
stem(0:N-1,abs(X));
ylabel('Magnitude');
xlabel('Bins');
mag =  20*log10(abs(X));
plot(k, mag);

phase=20*log10(angle(X));

figure;
plot(omega, phase);
ylabel('Phase');
xlabel('Bins');

mag_f0 =  abs(X(f0));
phase_f0 = angle(X(f0));


mag_f0_dB =  20*log10(abs(X(f0)));
phase_f0_dB = 20*log10(angle(X(f0)));
n = [0:L-1];

SNR = 50;
sz = size(x);
sigman2 = 10^(SNR/20);
noise = sqrt(sigman2).*randn(sz);
figure;
plot(n, noise);
A1 = A / 100 * 10;
HarmI = A1 * sin(2*pi*2*f0/fs*n + phi);
HarmII = A1 * sin(2*pi*3*f0/fs*n + phi);
sig_corrupted = x + noise + HarmI + HarmII;

figure;
plot(n, sig_corrupted);

media = mean(sig_corrupted);
vari = var(sig_corrupted);

sum1=0;
for i=1:length(sig_corrupted)
  sum1=sum1+sig_corrupted(i);
end
M=sum1/length(sig_corrupted); %the mean
sum2=0;
for i=1:length(sig_corrupted)
    sum2=sum2+ (sig_corrupted(i)-M)^2;
end
V=sum2/length(sig_corrupted); %Varaince
N = 2*N;
w0 = hanning(N);
w1 = blackman(N);
w2 = kaiser(N, 3);
w3 = bartlett(N);
w4 = hamming(N);


figure(30);
plot(1:2*N,w0,'r',1:2*N,w1,'b',1:2*N,w2,'k', 1:2*N, w3, 'g', 1:2*N, w4, 'y');


