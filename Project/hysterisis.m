function fh = hysterisis(f,tRT,tAT,tHT,UTH,LTH,Fs)  

% Hysteresis control raises the threshold for opening the gate and lowers that for closing it.

% f	- Output of static function (f=fd continued from inside of Dynamic filter)  
% tRT - Release Time : Time during which a signal less than threshold (lower) is faded into gated state. 
% tAT - Attack Time : Time before the output level is the same as input level after deactivating the gate. 
% tHT - Hold Time : Time for which a signal should remain below the threshold (lower) 
%                  before gate is activated (signal is blocked). 
% UTH - Upper Threshold : Threshold value for deactivating the gate. 
% LTH - Lower THreshold : Threshold value for activating the gate


% Converting to Samples
REL = round(tRT*Fs);
ATT = round(tAT*Fs);
HT = round(tHT*Fs);

% Initializing 
LTHcount=0; 
UTHcount=0;            
fh=zeros(size(f)); % Output 

for n=1:length(f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (f(n)<=LTH) |  ((f(n) < UTH) & (LTHcount>0))
        % Gate to be Activated(Closed) 
        
        LTHcount=LTHcount+1;
        UTHcount=0;
        
        if LTHcount>HT
            
            if LTHcount>(HT+REL)
                fh(n) = 0; % Gate fully Closed                
            else
                fh(n) = 1-(LTHcount-HT)/REL; % Gradually closing the Gate
            end;
            
        elseif ((LTHcount==n) & (n<HT))
            fh(n) = 0;     
        else
            fh(n) = 1; % Gate kept Opened
        end;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif (f(n) >= UTH) | ((f(n) > LTH) & (UTHcount>0))
        % Gate to be Deactivated(Opened)
        
        LTHcount=0;
        UTHcount=UTHcount+1;
        if (fh(n-1)<1)
            fh(n) = max(UTHcount/ATT, fh(n-1)); % Gradually opening the Gate 
        else
            fh(n) = 1; % Gate fully Opened
        end;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    else
        fh(n) = fh(n-1); % Gate fully Closed
        LTHcount = 0;
        UTHcount = 0;
    end;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;

  

            







