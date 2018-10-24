function yy=waterfspec(signal,start,steps,N,fS,clippingpoint,baseplane)
% waterfspec(signal,256,256,512,FS,20,-100);
% shows short-time spectra of signal, starting
% at k=start, with increments of STEP with N-point FFT 
% dynamic range from -baseplane in dB up to 20*log(clippingpoint)
% in dB versus time axis

echo off;
if nargin<7, baseplane=-100; end
if nargin<6, clippingpoint=0; end
if nargin<5, fS=48000; end
if nargin<4, N=1024; end         % default FFT
if nargin<3, steps=round(length(signal)/25); end
if nargin<2, start=0; end

window=blackman(N);              % window - default
window=window*N/sum(window);		% scaling

% Calculation of number of spectra NOS
  n=length(signal);
  rest=n-start-N;
  nos=round(rest/steps);
  if nos>rest/steps, nos=nos-1; end
% vectors for 3D representation
  x=linspace(0, fS/1000 ,N+1);
  z=x-x;
  cup=z+clippingpoint;
  cdown=z+baseplane;
  warning off; 
  signal=signal+0.0000001;  
% Computation of spectra and visual representation
  for i=1:1:nos,
  
      spek1e=fft(   window.*signal(1+start+i*steps:start+N+i*steps,1)  );  

      spek1d=abs(spek1e);

      spek1c=spek1d./(N)/0.5;   
      
      spek1b=log10(spek1c);
      spek1a=20*spek1b;
      
      spek1=spek1a;
     
      spek=[-200 ; spek1(1:N)];

      spek=(spek>cup').*cup'+(spek<=cup').*spek;

      spek=(spek<cdown').*cdown'+(spek>=cdown').*spek;

      spek(1)=baseplane-10;
      spek(N/2)=baseplane-10;
      y=x-x+(i-1);
      if i==1
          p=plot3(x(1:N/2),y(1:N/2)*(steps),spek(1:N/2),'k');
      end
      pp=patch(x(1:N/2),y(1:N/2)*(steps),spek(1:N/2),'w','Visible','on');
  end;
  warning on; 


axis([-0.3 fS/2000+0.3 0 nos*(steps) baseplane-10 0]);

