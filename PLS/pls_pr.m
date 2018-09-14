function y = pls_pr( x,p,X_mean,X_std,Y_mean,Y_std,b,r)
%说明：采用p_pls算法模型进行预测
% x：输入数据(辅助变量)
% p: pls计算的降维矩阵
% X_mean,X_std:训练数据均值和标准差
% Y_mean,Y_std：~
% b：标准化的回归系数
% r:多项式扩展主元个数
% y:预测数据


[n,~]=size(x);
%标准化
for j=1:n
    x(j,:)=(x(j,:)-X_mean)./X_std;
end

%求新数据成分ti
t=x*p;
T=t(:,1:r);

%****************************************

Y=T*b';%标准化预测值
y=Y*Y_std+Y_mean;%反标准化


