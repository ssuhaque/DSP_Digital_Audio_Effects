function y=delayEffect(x,Fs, tau, Delay, FB, Width, Depth, f,v,FF,BL)
% Audio multi Delay based effects with linear interpolation between the samples.

%x 		- input
%tau 		- amplitude of the time dependent delay in ms 
%Delay 	- delay offset in ms
%FB	- feedback gain
%FF - feedForward 
%BL - Blending gain 
%Width		- number of serial delay elements
%Depth		- number of parallell delay elements
%f 		- sinusoidal frequency of the time dependent delay
%Fs		- sampling frequency 

% Normal Values for variables 
% Delay:	tau=0 ,    Delay>25,    f=0,FB<1, Depth=1, Width=1  0<FB<1 , 0<FF<=1
% Flanger:	tau<15,    Delay<5,     f=0.1-20, Depth=1, Width=1, FB<1   , 0<FF<=0.5 
% Vibrato:	tau=0.1-2, Delay=0,     f=2-10,   Depth=1, Width=1, FB=0   , FF=1  
% Doubler:	tau=10-20, Delay=10-35, f=0.1-1,  Depth=1, Width=1, FB=0   , FF=0.5 
% Chorus:	tau=10-20, Delay=10-35, f=0.1-1,  Depth>3, Width=1, 0>FB>-1, FF=(Depth-1)/Depth

l=length(x);
o=round(Delay*Fs/1000);
t=round(tau*Fs/1000);
x=[zeros(t+2,1);x;zeros((o+t),1)];
q=zeros(size(x));
r=x;
step=(f/Fs)*(1:length(x));

for n=1:Width
    
    t=t*(Width-n+1)/Width;    
    for k=1:Depth
        z=zeros(size(x)); 
        if v==1 Mod=(1-cos(2*pi*(step+(k-1)/Depth)))/2; end; % Sinusoidal variation 
        if v==2 Mod=rand; end;   % Noise variation
        index=t*Mod;
        p=ceil(index);
        diff=(p-index)';    
        i=(1:l)+t+2;
        forward=(1-diff(i)).*r(i-p(i))+diff(i).*r(i+1-p(i));
    	for j=i
            z(j+o)=forward(j-t-2)+FB*((1-diff(j))*z(j-p(j))+diff(j)*z(j+1-p(j)));
    	end
    	q=q+z;
    end;    
    r=r+q;
    
end;

r=r*max(abs(x))/max(abs(r));
y=FF*r+BL*x;
y=y*max(abs(x))/max(abs(y));