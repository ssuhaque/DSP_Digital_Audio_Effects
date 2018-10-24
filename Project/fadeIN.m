function y=fadeIN(x)
% [x,fs,nbits]=wavread('ton2.wav');
yin=x';

step=1/length(yin);
fd=0:step:(1-step);

fadin=fd.*yin;
y=fadin';