function y=tremolo(x, amp, f, mix, Fs)

%Tremolo and ring modulation effect, sinusoidal

%x 	 - input
%amp - the amount of constant versus variabel amplitude, 
%	   0=only variabel, 1=constant amplitude, -1=ring modulator
%f 	 - the tremolo frequency
%mix - mix of modulated and original sound, mix=1 - only modulated
%Fs  - sampling frequency

step=1:length(x);
y(step)=(amp+(1-amp)/2*(1-cos(2*pi*(f/Fs)*step))).*x(step)';
y=mix*y'+(1-mix)*x;
