function y = pitch(signal,Fs,Sa,N,n1,n2)

%    analysis hop size     Sa  
%    block length          N   
%    pitch scaling factor  0.25 <= alpha <= 2  alpha=n1/n2
%    overlap interval      L  = 256*alpha/2
%    Ss=round(Sa*alpha)    Ss < N and Ss < N-L

signal=signal';
M=ceil(length(signal)/Sa);
alpha=n1/n2;

Ss=round(Sa*alpha);
L=256*(alpha)/2;

signal(M*Sa+N)=0;
Overlap=signal(1:N);

for k=1:M-1
  grain=signal(k*Sa+1:N+k*Sa);
  
  XCORRsegment=xcorr( grain(1:L),Overlap(k*Ss:k*Ss+(L-1)) );
  
  [xmax(k),index(k)]=max(XCORRsegment);
  
  fadeout = 1 : (-1/(length(Overlap)-(k*Ss-(L-1)+index(k)-1))) : 0;
  fadein  = 0 : ( 1/(length(Overlap)-(k*Ss-(L-1)+index(k)-1))) : 1;
  
  Tail=Overlap((k*Ss-(L-1))+ index(k)-1:length(Overlap)).*fadeout;
  Begin=grain(1:length(fadein)).*fadein;
  Add=Tail+Begin;
  Overlap=[Overlap(1:k*Ss-L+index(k)-1)  Add   grain(length(fadein)+1:N)];
end;

% for linear interpolation of a grain of length NN(=alpha*N) back to length N

NN=floor(N*alpha);
x=1+(0:N-1)'*NN/N;
M=floor(x);
frac=x-M;

lmax=max(N,NN);
Overlap=Overlap';

y=zeros(length(signal),1);

pin=0;
pout=0;
pend=length(Overlap)-lmax;

%  Pitch shifting by resampling a grain of length NN to length N
while pin<pend
  grain2=( Overlap(pin+M).*(1-frac)  +  Overlap(pin+M+1).*frac  )   .* HANNING(N,'periodic'); 
  y(pout+1:pout+N)=y(pout+1:pout+N)+grain2;
  pin=pin+n1;pout=pout+n2;
end;