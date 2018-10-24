function y = Noise_gate(x,T,NT,NS,tRT,tAT,tH,UTH,LTH,Fs,Hoption,env,a)

% x - Input Signal 
% T - Sampling period

% NT - Noise gate Threshold 
% NS - Noise gate Slope factor 

% tRT - Release Time 
% tAT - Attack Time 
% tH - Hold Time (for hysterisis function) 
% UTH - Upper Threshold (for hysterisis function) 
% LTH - Lower THreshold (for hysterisis function) 
% a Pole placement of the envelope detecting filter <1

f=zeros(size(x));

if env==1
    x_peak=peak_measurement(x,T,tRT,tAT);

    f(1)=1;
    for n=2:1:length(x)
        if x_peak(n) >NT
            f(n)=10^(-NS * ( log(x_peak(n))-log(NT)  )  );
        else
            f(n) =1;
        end;
    end;
else
    %detects the envelope of x with a second order LP filter
    f=filter([(1-a)^2],[1.0000 -2*a a^2],abs(x));		
    f=f/max(f);
end;

if Hoption==1
    g = dynamic_Filter(f,tRT,tAT,tH,UTH,LTH,Fs,0);
else
    g=f;
end;

y=x.*g;
y=y*max(abs(x))/max(abs(y));