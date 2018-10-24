function g = dynamic_Filter(f,tRT,tAT,tHT,UTH,LTH,Fs,sw)

% Used for attack and release time adjustments

% f	- Output of static function  
% tRT - Release Time 
% tAT - Attack Time 
% tHT - Hold Time (for hysterisis function) 
% UTH - Upper Threshold (for hysterisis function) 
% LTH - Lower THreshold (for hysterisis function) 



if sw==1
    
    fd= [0;f(1:length(f)-1)]-f;
    fh = hysterisis(fd,tRT,tAT,tHT,UTH,LTH,Fs);
    g=zeros(size(f)); % Output
    g(1)=0;
    for n=2:length(f)
        fs(n) = f(n) - g(n-1);
        fsh(n) = fh(n)* fs(n);
        g(n) = fsh(n) + g(n-1);
    end
    
else
    g=hysterisis(f,tRT,tAT,tHT,UTH,LTH,Fs);
end

