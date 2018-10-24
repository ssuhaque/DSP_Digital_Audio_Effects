function y=symclip(x,th)

% "Overdrive" simulation with symmetrical soft clipping (by Schetzen Formula) 
% x  - input
% th - threshold<1

for i=1:1:length(x)
   
    if abs(x(i)) < th
       y(i)=2*x(i);
   end;
   
   if abs(x(i)) >= th 
      if x(i)> 0, y(i)=(3-(2-x(i)*3).^2)/3; end;
      if x(i)< 0, y(i)=-(3-(2-abs(x(i))*3).^2)/3; end;
   end;   
   
   if abs(x(i)) > 2*th 
      if x(i)> 0, y(i)=1;end;
      if x(i)< 0, y(i)=-1;end;
   end;
   
end;

y=y';