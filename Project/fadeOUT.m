function y=fadeOUT(x)
% [x,fs,nbits]=wavread('TON2.wav');
yin=x';

step=1/length(yin);
fd=1:-step:(0+step);

fadout=fd.*yin;
y=fadout';