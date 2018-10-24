function y = generator(type,f,duration,amplitude,Fs)

% Signal Generator for common Test Signal Types

% f: Sets the frequency of the signal from 1 to Fs/2 in Hz
% duration: Sets the duration of the signal in seconds
% amplitude: Sets the amplitude of the generated signal from [0] to [1]
% Fs: Sets the sampling frequency of the generated test signal in Hz

% type: Specifies the type of the signal 
% 1:Sine  2:Cosine  3:Square  4:Triangular  5:Pulse  6:Step function 
% 7:Unit impulse   8:Ramp function    9:Exponential function
                              
t=0:1/Fs:duration;   %vector t depending on the duration of the signal and the sampling frequency 

switch (type)
    
case (1) %generates a sine signal
    signal=amplitude*sin(2*pi*f*t);
    y=signal';
    
case (2) %generates a cosine signal
    signal=amplitude*cos(2*pi*f*t);
    y=signal';
    
case (3) %generates a square signal
    signal=square(2*pi*f*t);  
    signal=signal*amplitude;
    y=signal';
    
case (4) %generates a triangular signal
    signal=sawtooth(2*pi*f*t,0.5);
    signal=signal*amplitude;
    y=signal';
    
case (5) %generates a pulse sequence
    signal=cos(2*pi*f*t);
    for s=1:length(t)
        if signal(1,s)==1
            signal2(1,s)=1; 
        elseif signal(1,s)==-1;
            signal2(1,s)=-1;
        else signal2(1,s)=0;    
        end
    end
    signal2=signal2*amplitude;
    y=signal2'; 
    
case (6) %generates a Step function signal
    signal=ones(1,length(t));
    y=signal';
    
case (7) %generates a Unit impulse signal
    signal=[1];
    y=signal';
    
case (8) %generates a Ramp function signal
    signal=1:1:length(t);
    y=signal';
    
case (9) %generates a Exponential function signal
    signal=exp(amplitude*(1:1:length(t)));
    y=signal';
end