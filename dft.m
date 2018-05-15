
function X = dft(x,N)

% Performs the DFT of the sequence x over N samples

j=complex(0,1);
L=length(x);

if N<L
    disp('warning: time aliasing may occur in case of inverse transformation');    
    x_e=x(1:N);
elseif N>L
    x_e=x;
    for n=(L+1):N
        % zero padding
        x_e(n)=0;
    end; 
else    
    x_e=x;
end;    
n=0:length(x_e)-1;
k=0:N-1;
V = exp(-j*2*pi/N*n'*k);    % Matrix of twiddle factors
X = x_e*V; % the DTFT (matrix product)


figure();
stem(n, X);
zoom xon;
return;







