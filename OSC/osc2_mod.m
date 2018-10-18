function [ pr,wr,X ] = osc2_mod( x,y,r)
%说明：LS法正交信号校正，ls_osc，求权值矩阵采用了ls回归算法。
% x:训练数据自变量
% y:训练数据因变量
% r:正交信号校正成分个数
% pr:特征矩阵
% wr:权值矩阵

%r=3;osc成分个数
X=x;
mm=size(x,2);
for i=1:r
    X_cov=cov(X);
    [L, K]=eig(X_cov); %计算特征值K、特征向量L
    p=L(:,end);
    t1=X*p;%最大主成分

%  %计算最大主成分的另一种方法   
%     [u,s,v] = svds(X,1);
%      p = v(:,1);
%      p = p*sign(sum(p));
%      told = u(:,1)*s(1);

%***************************************************
%循环计算主成分t1中与y正交的部分
    dif=1;k=0;fn=500;   told=t1;
    while dif > 1e-12
        k=k+1;
        t=X*p/(p'*p);
        tnew=t- y*inv(y'*y)*y'*t;%tnew是t与y正交的信息
        pnew=X'*tnew/(tnew'*tnew);%pnew是变换向量，tnew=x*pnew;
        dif=norm(tnew-told)/norm(tnew);%达到一定精度结束
        p=pnew;
        told=tnew;
        if k>fn
            dif=0;
        end
    end
    
%******************************************************************
    w=tnew'*X/(X'*X);%最小二乘求回归系数w
    w=w';
    t=X*w;%
    X=X-t*p';
    
    pr(:,i)=p;
    wr(:,i)=w;
    tr(:,i)=t;
    
end

end

