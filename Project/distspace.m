function y=distspace(x,Fs,distwall,offset,lenh)
c=300;
% Exponentialy decaying Signal
exsignal=exp(-[1:lenh]*0.01/distwall)/100;
% Gaussian Noise  
Noise= random('norm',0,1,1,lenh);

% Exponentialy decaying Gaussian Noise  
GN=Noise.*exsignal;

% Filter effect due to wall
Hw = filter([0.5,0.5],1,GN);
x=x';
y=0;
for i = 1:1:distwall-1 % several distances listener-source
    
    % Estimated Signal Time 
    ST=i*Fs/2;
    
    % Delays in Samples
    del1 = floor(Fs*i/c);                  % For Direct
    del2 = floor((distwall*2 - i)/c*Fs);   % For Reflected
    % Introducing delay of direct signal 
    y(ST+1 : ST+del1) = zeros(1,del1);
    % Introducing attenuated direct signal 
    y(ST+del1+1 : ST+del1+length(x)) = x./(1+i); 
    % Artifical reverberant tail with delay
    tail=[zeros(1,offset),conv(x,Hw)]/sqrt(1+i);
    y(length(y):ST+del2)=0;
    % Appending tail to Output  with "del2" delay (direct signal + delayed reverb)
    y(ST+del2+1 : ST+del2+length(tail))= zeros(1,length(tail)); 
    y(ST+del2+1 : ST+del2+length(tail)) = y(ST+del2+1 : ST+del2+length(tail)) + tail(1:length(tail)) ;                                                        
end
y=y';