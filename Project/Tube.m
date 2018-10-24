function y=tube(x, gain, Q, dist, rh, rl, mix)
%"Tube distortion" simulation, asymmetrical transfer funktion.

%x    - input
%mix  - mix of original and distorted sound, 1=only distorted
%gain - the amount of distortion, >0->
%Q    -	work point. Controls the linearity of the transfer function for low input levels, more negative=more linear
%dist - controls the distortion's character, a higher number gives a harder distortion, >0
%rl   -	0<rl<1. The pole placement in the LP filter which is used to simulate capasitances in a tube amplifier
%rh   - abs(rh)<1, but close to 1. The placement of the poles in the HP filter which 
%	    removes the DC component which is introduced by the asymmetric transfer function



q=x*gain/max(abs(x));			%Normalization

for i=1:1:length(q)
    if Q==0                                                       % Second term is zero
        z(i)=q(i)/(1-exp(-dist*q(i))); 
        if q(i)==Q   z(i)=1/dist;	end;	                      % To avoid 0/0 inf value              
    else                                                          
        z(i)=(q(i)-Q)  ./  (1-exp(-dist*(q(i)-Q))) +   Q/(1-exp(dist*Q));
        if q(i)==Q  z(i)=(1/dist)+Q/(1-exp(dist*Q)); end;            % To avoid 0/0 inf value   
    end;     
end;

z=z';
y=mix*z*max(abs(x))/max(abs(z))+(1-mix)*x; %Normalization
y=y*max(abs(x))/max(abs(y));			   %Normalization
y=filter([1 -2 1],[1 -2*rh rh^2],y);	   %HP filter
y=filter([1-rl],[1 -rl],y);	               %LP filter