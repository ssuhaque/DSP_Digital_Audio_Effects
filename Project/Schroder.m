function y=schroder(x,Fs,T60,g,gL,k,offsetComb,offsetAP,mix,n,aCoeff)

% Schroders reverberation algorithm, values after Moorer

% x	- input
% g	- feedback gain in the all pass filter
% k	- how much longer the file should be made in seconds 
% Fs  - sampling frequency 
% T60 - the "DC" reverberation time in the comb filters
% mix - mix of original and delayed sound, 0=only original, 1=only delayed


K=round(k*Fs);	 
x=[x;zeros(K,1)];
a=zeros(1,max(n));
b=1;
a(n)=aCoeff
x=filter(a,b,x);

mixComb=1;
kComb=1;
z1=delayfblp(x,offsetComb(1),T60,gL(1),kComb,mixComb,Fs);
z2=delayfblp(x,offsetComb(2),T60,gL(2),kComb,mixComb,Fs);
z3=delayfblp(x,offsetComb(3),T60,gL(3),kComb,mixComb,Fs);
z4=delayfblp(x,offsetComb(4),T60,gL(4),kComb,mixComb,Fs);
z5=delayfblp(x,offsetComb(5),T60,gL(5),kComb,mixComb,Fs);
z6=delayfblp(x,offsetComb(6),T60,gL(6),kComb,mixComb,Fs);
 
z=z1+z2(1:length(z1))+z3(1:length(z1))+z4(1:length(z1))+z5(1:length(z1))+z6(1:length(z1));

kAP=1;
r=allpass(z,offsetAP,g,kAP,Fs);

y=mix*r(1:length(x))+(1-mix)*x;
y=y*max(abs(x))/max(abs(y));	%prevents overload distortion