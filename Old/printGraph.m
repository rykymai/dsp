function [ mag, phi, mag_dB, phase_dB ] = printGraph( X, omega, N, f0 )
omega = 0:N-1*2*pi/N;
%Spectral Plots 
figure;
stem(0:N-1, abs(X));
ylabel('Magnitude');
xlabel('Bins');

mag =  20*log10(abs(X));
figure;
plot(omega, mag);

phi=20*log10(angle(X));

figure;
plot(omega, phi);
ylabel('Phase');
xlabel('Bins');

mag =  abs(X(f0));
phi = angle(X(f0));

mag_dB =  20*log10(abs(X(f0)));
phase_dB = 20*log10(angle(X(f0)));
end

