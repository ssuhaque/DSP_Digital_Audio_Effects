function y=fuzz(type, x, gain, mix)

% x    - input
% gain - amount of distortion, >0->
% type - type of distortion 
% mix  - mix of original and distorted sound, 1=only distorted

q=x*gain/max(abs(x));

if type==1 z=sign(-q).*(1-exp(sign(-q).*q)); end;%Distortion based on an exponential function
if type==2 z=atan(q);  end;                      %Distortion based on inverted tangens function  
if type==3 z=sign(x).*sqrt(abs(x)); end;         %Distortion based on square root function


y=mix*z*max(abs(x))/max(abs(z))+(1-mix)*x;
y=y*max(abs(x))/max(abs(y));