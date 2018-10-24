function y=delayfblp(x, offset, T60, a, k, mix, Fs)

%Delay effect with a low pass filter in the feedback loop
%
%x 		- input
%offset 	- delay in ms
%T60		- reverberation time if a=0
%a		- pole placement for the low pass filter
%k		- constant which tells MATLAB how much longer the signal should be. 
%		  The signalet is made k*offset milliseconds longer, k>=1 
%mix 		- mix original and delayed sound, 0=only original, 1=only delayed
%Fs		- samplingfrequenzy
%
%Delay:		offset>?, feedback<1

feedback=(1-a)*10^(-3*offset/(1000*T60));	%transformation reverberation time/feedback gain
l=length(x);			%The original length of the sound
o=round(offset*Fs/1000);	%delay in number of samples
x=[0;x;zeros(k*o,1)];
z=zeros(size(x));

for j=1+(1:(l+(k-1)*o))		%For each sampel
  z(j+o)=x(j)+feedback*(z(j)+a*z(j-1))*(1-a);
end;

y=mix*z+(1-mix)*x;
y=y*max(abs(x))/max(abs(y));	%Prevents overload distortion