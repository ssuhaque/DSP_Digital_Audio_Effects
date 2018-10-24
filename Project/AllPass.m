function y=allpass(x, offset, feedback, k, Fs)

%Allpass filter for reverberation simulation

%x 		- input
%offset 	- delay in ms
%feedback	- amplification in the feedback loop
%k		- the signal is made k*offset milliseconds longer, k>=1 
%Fs		- the sampling frequency of the input

l=length(x);			%the original length of the signal
o=round(offset*Fs/1000);	%delay in number of samples
x=[x;zeros(k*o,1)];
z=zeros(size(x));

for j=1:(l+(k-1)*o)		%For each sample
  z(j+o)=x(j)+feedback*z(j);
end;

y=(1-feedback^2)*z-feedback*x;
% y=y*max(abs(x))/max(abs(y));	%To prevent overload when converting to a .wav-file