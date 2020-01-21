function [ mag, phi, mag_dB, phase_dB] = printGraph( X, omega, N)
%omega = 0:N-1*2*pi/N;
%Spectral Plots 
figure('Name', 'ABS(X)');
stem(0:N-1, abs(X));
ylabel('Magnitude');
xlabel('Bins');

magf =  20*log10((X));
figure('Name', 'MAG[ABS(X)]');
plot(omega, magf);
xlim([omega(1) omega(end)]);
%stem(omega, mag);
%[pks,loc]=findpeaks(magf);
% pks
% loc
phi=20*log10(angle(X));

phif = angle(X);
figure('Name', 'angle ABS(X)');
subplot(2,1,1);
plot(omega, phi);
xlim([omega(1) omega(end)]);
%stem(omega, phi);
ylabel('Phase dB');
xlabel('Bins');
subplot(2,1,2);

plot(omega, phif);
xlim([omega(1) omega(end)]);
%stem(omega, phi);
ylabel('Phase');
xlabel('Bins');
 
%mag =  abs(X(N/2));
mag1 =  abs(X(N/2));
mag =  abs(X(2));
phi = angle(X(N/2));

mag_dB =  20*log10(abs(X(N/2)));
phase_dB = 20*log10(angle(X(N/2)));
end


