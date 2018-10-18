function [ pr,wr,X ] = osc1_mod( x,y,r)
%说明：PLS法正交信号校正，pls_osc，求权值矩阵采用了pls回归算法。
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
    p1=L(:,end);
    t1=X*p1;%最大主成分

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
        t=X*p1/(p1'*p1);
        tnew=t- y*inv(y'*y)*y'*t;%tnew是t与y正交的信息
        pnew=X'*tnew/(tnew'*tnew);%pnew是变换向量，tnew=x*pnew;
        dif=norm(tnew-told)/norm(tnew);%达到一定精度结束
        p1=pnew;
        told=tnew;
        if k>fn
            dif=0;
        end
    end
    
%******************************************************************
    %采用PLS方法继续优化该正交信息tnew
    %w=pls(X,tnew,a);%实际上w是X对tnew的PLS回归系数,也可用PCR或MLR求w
    E0=X;F0=tnew; temp=eye(mm);
    for j=1:mm
        M=E0'*F0*F0'*E0;
        [LL, KK]=eig(M); %计算特征值K、特征向量T
        S=diag(KK);%提取特征值
        [~,ind]=sort(S,'descend');%按大-小排序，ind序号
        ww(:,j)=LL(:,ind(1)); %提出最大特征值对应的特征向量
        tt(:,j)=E0*ww(:,j);     %计算成分 ti 的得分
        alpha(:,j)=E0'*tt(:,j)/(tt(:,j)'*tt(:,j)) ;%计算                 alpha_i ,其中(t(:,j)'*t(:,j))等价于norm(t(:,j))^2
        E1=E0-tt(:,j)*alpha(:,j)' ;   %计算残差矩阵
        E0=E1;
        
       %计算w*矩阵
       if j==1
           w_star(:,j)=ww(:,j);
       else
          for jj=1:j-1
              temp=temp*(eye(mm)-ww(:,jj)*alpha(:,jj)');
          end
          w_star(:,j)=temp*ww(:,j);
       end   
    end
    T=tt(:,1:r);
    b=tnew'*T/(T'*T);%标准化对主元的回归系数
    w=w_star(:,1:r)*b';%标准化对X的回归系数（另外有T=X*w_star，并可用推导出w）
   
 %*********************************************************************   
    t=X*w;%pls回归预测值
%     t=t-y*inv(y'*y)*y'*t;%这一步作用不好加入预测数据
    p=X'*t/(t'*t); 
    X=X-t*p';
    
    pr(:,i)=p;
    wr(:,i)=w;
    tr(:,i)=t;
    
end

end

