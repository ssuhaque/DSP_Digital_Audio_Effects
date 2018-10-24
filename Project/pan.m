function y = pan(input,type,pAngle,iAngle,fAngle,segments)
       
% initial_angle and final_angle are in degrees 

[a,b]=size(input);

if b==1
    x =[input , input];% stereo signal 
end;

if type==1 
    
    pAngle = pAngle * pi / 180; %in radians
    A =[cos(pAngle), sin(pAngle); -sin(pAngle), cos(pAngle)];
    y =x*A;
    
else
    
    y=zeros(length(x)*segments,2);
    angle_increment = (iAngle - fAngle)/segments * pi / 180; % in radians
    angle = iAngle * pi / 180; %in radians
    for i=1:segments
        A =[cos(angle), sin(angle); -sin(angle), cos(angle)];
        y(1+(i-1)*length(x):i*length(x),1:2) =x*A;
        angle = angle + angle_increment; 
    end;
    
end;
