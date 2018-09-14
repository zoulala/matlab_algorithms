function  [ p,X_mean,X_std,Y_mean,Y_std,b] = pls_mod( x,y,r )
%说明：采用pls算法建模。
% x：输入训练数据(辅助变量)
% y: 输入训练数据（化验值）
% r：主成分个数
% p: 降维矩阵，t=x*p；
% X_mean,X_std:训练数据均值和标准差
% Y_mean,Y_std：~
% b：标准化的回归系数



X=zscore(x);X_mean=mean(x);X_std=std(x);
Y=zscore(y);Y_mean=mean(y);Y_std=std(y);
[~,mx]=size(X);

E0=X;F0=Y;
for i=1:r
    M=E0'*F0*F0'*E0;
    [L, K]=eig(M); %计算特征值K、特征向量T
    S=diag(K);%提取特征值
    [~,ind]=sort(S,'descend');%按大-小排序，ind序号
    w(:,i)=L(:,ind(1)); %提出最大特征值对应的特征向量
    t(:,i)=E0*w(:,i);     %计算成分 ti 的得分
    ap(:,i)=E0'*t(:,i)/(t(:,i)'*t(:,i)) ;%计算特征矩阵ap
    E1=E0-t(:,i)*ap(:,i)' ;   %计算残差矩阵
    E0=E1;
        
end

T=t(:,1:r);

%****************************************
b=Y'*T/(T'*T);%对主元的回归系数

%得到X降维矩阵p
temp=eye(mx);%对角阵
for i=1:r
       if i==1
           p(:,i)=w(:,i);
       else
          for j=1:i-1
              temp=temp*(eye(mx)-w(:,j)*ap(:,j)');
          end
          p(:,i)=temp*w(:,i);
       end 
end



end

