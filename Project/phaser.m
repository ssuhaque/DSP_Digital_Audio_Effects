function y=phaser(x, window, mix, fc, fs, fb, FB, depth ,pass)

% Phaser effect with second order all pass filter

% x	- input signal 
% window	- the number of samples filtered between each update of the filter coefficients
% pass - Number of parallel filters

% mix - mix of modulated and original sound, mix=1 - only modulated
% FB - gian of feedback signal

% fc - center frequency Hz
% fs - sampling frequency Hz
% fb - bandwidth Hz
% depth - amount of variation around center frequency Hz


k=ceil(length(x)/window); % number of full frames
n=k*window-length(x);     % number of bits left  
x=[x;zeros(n,1)];		  % zero padding of x to make total length a whole no of frames (k frames) 
z=zeros(size(x));         % z is the output signal of the bandpass filters 
Zi=zeros(2,pass);         % initial status of parallel filters (2 is the order of filter)
Zf=zeros(2,pass);         % final status of parallel filters (2 is the order of filter)

dTH=2*pi*fc/fs;
fc=(    fc+depth/2*cos(0:dTH:dTH*(k*window-1))  )'; % varing frequency of the filter 

for i=1:k % for each window 
    
  c=( tan(pi*fb/fs)-1 ) / ( tan(2*pi*fb/fs)+1 ) ; 
  d=-cos( 2*pi*fc(((i-1)*window)+1:i*window)/fs );
  g=x((i-1)*window+1:i*window); % Input at the end of parallel filters;
  
  for p=1:pass % for each parallel filter
      for j=1:window % for each sample of a window 
          b=[-c,d(j)*(1-c), 1];
          a=[1 ,d(j)*(1-c),-c];
          [ z((i-1)*window+j) , Zf(1:2,p)] = filter(b, a, g(j), Zi(1:2,p));
          Zi(1:2,p)=Zf(1:2,p);
      end
      g(1:window)=z((i-1)*window+1:i*window); % input to next filter 
  end
  
  if k-i>pass % Feedback 
    x((i+pass)*window+1:(i+pass+1)*window) = x((i+pass)*window+1:(i+pass+1)*window) + FB*z((i-1)*window+1:i*window);
  end;   
  
end

y=mix*z+(1-mix)*x;
y=y*max(abs(x))/max(abs(y)); % Normalization 
size(y)