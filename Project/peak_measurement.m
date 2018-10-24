function y = peak_measurement(x,T,tRT,tAT)

% x	- input signal 
% T - Sampling period
% tRT - Release Time 
% tAT - Attack Time 

RT=1-exp( (-2.2*T)/tRT );
AT=1-exp( (-2.2*T)/tAT );

x_peak(1)=0;

for n=2:1:length(x)
    a=abs(x(n));
    a=a-x_peak(n-1);
    if a<0 a=0; end;
    x_peak(n)=(x_peak(n-1)*(1-RT))+(AT*a);
end


y=x_peak;