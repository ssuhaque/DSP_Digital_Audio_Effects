% x	- input signal 
% f  - frequency of the delay variations
% Fs - sampling frequency
% Delay - fixed delay 
% Width - Width of Delay to be varied 
% note that total delay will be 'DELAY+WIDTH*Mod' Mod varies Width 
% v - variation type (v==1 for Sinusoidal variation) & (v==2 for AWGN variation)
% p - Number of Parallel delay line 

% BL - blending gain 
% FF - forward gain  
% FB - feedback gain 

DELAY=round(Delay*Fs); % basic delay in # samples
WIDTH=round(Width*Fs); % modulation Width in # samples
function y=delayEffect(x,Fs,BL,FB,FF,f,Delay,Width,v,p)
MODFREQ=f/Fs;          % modulation frequency in # samples

L=2+DELAY+(WIDTH*2);   % length of the entire delay  
%  To simplify the interpolation process a bit, the delayline is made one sample longer than necesary 
%  where the first point is a copy of the last. 

y=zeros(length(x),p);  % memory allocation for output vector of each delay line 

for pn=1:p
    Delayline=zeros(L,1); % memory allocation for delay
    for n=1:length(x)
        
        if v==1 Mod=sin(2*pi*MODFREQ*n); end; % Sinusoidal variation 
        if v==2 Mod=rand; end;   % Noise variation
        
        totalD=1+DELAY+WIDTH*Mod;
        i=floor(totalD);
        frac=totalD-i;
        
        xh=x(n)+FB*Delayline(i);
        yh(n)=FF*Delayline(i)+BL*xh; 
        Delayline=[xh;Delayline(1:L-1)];
        
        %---Linear Interpolation-----------------------------        
        y(n,pn)=Delayline(i+1)*frac+Delayline(i)*(1-frac);
    end;
end;

output=zeros(size(x));

for pn=1:p
    for n=1:length(x)
        output(n)=output(n)+y(n,pn);
    end
end

y=output;
y=y*max(abs(x))/max(abs(y)); % To prevent overload distortion

% Low pass filter of first order to remove metalic noise 
% LP=fir1(1,0.20);
% y=conv(LP,y); 