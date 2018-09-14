function [B b]=plskernel_1(X,Y,A)
[N K]=size(X);
[Nn M]=size(Y);
meanX=mean(X);
meanY=mean(Y);
stdX=std(X);
stdY=std(Y);

X=zscore(X);
Y=zscore(Y);

XY=X'*Y;
XX=X'*X;
W=[];
P=[];
Q=[];
R=[];
for i=1:A
    if M==1
        w=XY;
    else
        [C,D]=eig(XY'*XY);
        q=C(:,find(diag(D)==max(diag(D))));
        w=(XY*q);
    end
    w=w/sqrt(w'*w);
    r=w;
    for j=1:i-1
        r=r-(P(:,j)'*w)*R(:,j);
    end
    tt=(r'*XX*r)+1e-100;
    p=(r'*XX)'/tt;
    q=(r'*XY)'/tt; 
    XY=XY-(p*q')*tt;
    W=[W w];
    P=[P p];
    Q=[Q q];
    R=[R r];
end
beta=R*Q';
B=stdY*beta./(stdX'+1e-20*ones(1,size(X,2))');
b=meanY-meanX*B;