function y = RMS_measurement(x,T,tTAV)

% x	- input signal 
% T - Sampling period
% tTAV - Averaging Time 

TAV=1-exp( (-2.2*T)/tTAV );

x_RMS(1)=0;

for n=2:1:length(x)
    a=(x(n))^2;
    a=a + x_RMS(n-1);
    a=a*TAV;
    x_RMS(n)=x_RMS(n-1)+a;
end

y=x_RMS;