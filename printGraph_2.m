function [mag, phi, mag_dB, phase_dB, magf, phif, mag_dB_f] = printGraph_2( X, N)
%omega = 0:N-1*2*pi/N;
%Spectral Plots 

magf = abs(X);

mag_dB_f =  20*log10(abs(X));


phi=20*log10(angle(X));
phif = angle(X);


mag =  abs(X(N/2));
phi = angle(X(N/2));

mag_dB =  20*log10(abs(X(N/2)));
phase_dB = 20*log10(angle(X(N/2)));
end