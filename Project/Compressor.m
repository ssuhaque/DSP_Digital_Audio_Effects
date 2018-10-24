function y = Compressor(x,T,CT,CS,tRT,tAT,tTAV,tH,UTH,LTH,Fs,Hoption,env,a,comp)

% x - Input Signal 
% T - Sampling period

% CT - Compressor Threshold 
% CS - Compressor Slope factor 

% tRT - Release Time 
% tAT - Attack Time 
% tTAV - Averaging Time 

% comp	- compression: 0>comp>-1
%	      expantion:   0<comp<1

% tH - Hold Time (for hysterisis function) 
% UTH - Upper Threshold (for hysterisis function) 
% LTH - Lower THreshold (for hysterisis function)
% a - pole placement of the envelope detecting filter <1

f=zeros(size(x));

if env==1
    x_RMS=RMS_measurement(x,T,tTAV);
    f(1)=1;
    for n=2:1:length(x)
        if x_RMS(n) >CT
            f(n) =10^(-CS * ( log(x_RMS(n))-log(CT)  )  );
        else
            f(n)=1;    
        end;
    end;
else
    %detects the envelope of x with a second order LP filter
    f=filter([(1-a)^2],[1.0000 -2*a a^2],abs(x));		
    f=f/max(f);
end


if Hoption==1
    g = dynamic_Filter(f,tRT,tAT,tH,UTH,LTH,Fs,0);
else
    g=f;
end;

if env==1
    y=x.*g;
else
    h=g.*f.^comp;
    y=x.*h;
end

y=y*max(abs(x))/max(abs(y));