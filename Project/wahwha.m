function y=wahwha(x, window, mix, Fc, Fs, fmax, fmin ,pass)

% Wha-wha effect with second order bandpass filter

% x	- input signal 
% window	- the number of samples filtered between each update of the filter coefficients
% pass - Number of serial filters

% mix - mix of modulated and original sound, mix=1 - only modulated
% Fc - center frequency Hz (the wah wah's frequency)
% Fs - sampling frequency Hz
% Fb - bandwidth Hz
% fmin - Lower end of bandwidth
% fmax - Upper end of bandwidth
% depth - amount of variation around center frequency Hz
% a	- a<1, pole placement in the resonator

Fb=fmax-fmin;
a=0.95;

k=ceil(length(x)/window); % number of full frames
n=k*window-length(x);     % number of bits left  
x=[x;zeros(n,1)];		  % zero padding of x to make total length a whole no of frames (k frames) 
z=zeros(size(x));         % z is the output signal of the bandpass filters 
Zi=zeros(2,pass);         % initial status of parallel filters (2 is the order of filter)
Zf=zeros(2,pass);         % final status of parallel filters (2 is the order of filter)

omega=2*pi*Fc*window/Fs;
omegamax=pi*fmax/Fs;
min=1-fmin/fmax;

for i=1:k % for each window
    g=x((i-1)*window+1:i*window); % Input at the end of serial filters;
    for p=1:pass % for each serial filters
        [z((i-1)*window+1:i*window),Zf(1:2,p)]=filter([1],[1 -2*a*cos(omegamax*(1-min*cos(omega*i))) a^2],g(1:window),Zi(1:2,p));
        Zi(1:2,p)=Zf(1:2,p);
        g=z((i-1)*window+1:i*window); % input to next filter
    end;
end;


y=mix*z+(1-mix)*x;
y=y*max(abs(x))/max(abs(y)); % Normalization 


% dTH=2*pi*Fc/Fs;
% Fc=(    Fc+depth/2*cos(0:dTH:dTH*(k*window-1))  )'; % varing frequency of the filter 
% 
% for i=1:k % for each window 
%     
%   c=( tan(pi*Fb/Fs)-1 ) / ( tan(2*pi*Fb/Fs)+1 ) ; 
%   d=-cos( 2*pi*Fc(((i-1)*window)+1:i*window)/Fs );
%   g=x((i-1)*window+1:i*window); % Input at the end of serial filters;
%   
%   for p=1:pass % for each serial filters
%       for j=1:window % for each sample of a window 
%           b=[1+c,0,-1-c];
%           a=[2 ,  2*(1-c)*d(j)  ,-2*c];
%           [ z((i-1)*window+j) , Zf(1:2,p)] = filter(b, a, g(j), Zi(1:2,p));
%           Zi(1:2,p)=Zf(1:2,p);
%       end
%       g=z((i-1)*window+1:i*window); % input to next filter
%   end
%     
% end
