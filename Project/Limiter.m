function y = Limiter(x,T,LT,LS,tRT,tAT,tHT,UTH,LTH,Fs,Hoption,Hs)

% x - Input Signal 
% T - Sampling period

% LT - Limiter Threshold 
% LS - Limiter Slope factor 

% tRT - Release Time 
% tAT - Attack Time 
% tHT - Hold Time (for hysterisis function) 
% UTH - Upper Threshold (for hysterisis function) 
% LTH - Lower THreshold (for hysterisis function) 

% Hysterisis=1 use hysterisis / Hysterisis=0 no hysterisis
% Hs - for Hard Hs=2 for soft Hs=1

if Hs==1
    x_peak=peak_measurement(x,T,tRT,tAT);
    f=zeros(size(x));
    f(1)=1;
    for n=2:1:length(x)
        if x_peak(n) >LT
            f(n)=10^(-LS * ( log(x_peak(n))-log(LT)  )  );
        else
            f(n) =1;
        end;
    end;
    
    if Hoption==1
        g = dynamic_Filter(f,tRT,tAT,tHT,UTH,LTH,Fs,0);
    else
        g= f;
    end;
    
    y=x.*g;
    y=y*max(abs(x))/max(abs(y));
    
else
    h=filter(1e-5*[0.45535887 0.91071773849 0.45535887],[1 -1.99395528   0.993973494],abs(x));
	%detects the envelope of the signal with a second order Butterworth filter, cut off frequency: 30Hz
    h=h/max(h);
    for i=1:length(x)		
        if h(i)>LT			%if the signal envelope is above the limit
            x(i)=x(i)*LT/h(i);	
        end;
    end;
    y=x;
end
