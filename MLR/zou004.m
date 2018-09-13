%***********************此程序为多元逐步回归分析******
clc;clear;close all;
[num,TXT,raw]=xlsread('F:\独山子项目\数据提取\obsoft\fccu-pls.xlsx','柴油初馏点');
%num(1:2,:)=[];
num=num(:,1:11);
% x=num(:,1);
% y=x';%所有y数据
% figure;
% subplot(211);
% plot(y,'b.-');ylabel('y');title('含异样点数据');
% axis([0,500,280,320]);
% hold on;
% %%%减去平均值后大于标准差的3倍，则剔除
% x_mean=mean(x);
% x_std=std(x);
% xx=abs((x-x_mean)/x_std);
% k= find(xx>=3);
% plot(k,y(k),'ro')
% x(xx>=3)=[];
% disp('被剔除的点为：');
% disp(find(xx>=3));
% yy=x';%去异常点后y数据
% subplot(212);
% plot(yy,'r.-');ylabel('y');title('剔除异常点后数据');
% axis([0,500,280,320]);
% num(xx>=3,:)=[];%去除异常点后xy数据

In=zbhg(num);%逐步回归

x=num(1:end,In+1);
y=num(1:end,1);

X=x;%训练数据
Y=y;
XX=num(:,In+1);%测试数据
YY=num(:,1);
[m,mm]=size(XX);
[n,p]=size(X);
X=[ones(n,1),X];
XX=[ones(m,1),XX];
[n,m]=size(X);
alpha=0.95;
% [b,bint,r,rint,stats]=regress(y,X);   %b为参数，bint回归系数的区间估计，r为残差，rint为置信区间，stats用于回归模型检验.

b=(X'*X)\X'*Y %回归系数
yy=XX*b;%预测值
figure;
plot(YY,'b.-');title('多元线性回归');
hold on
plot(yy,'r.-');
hold off;
legend('real value','prediction of MLR');

% ********  离差和参数计算  *****************
Y_mean=mean(YY);
SSE=(YY-yy)'*(YY-yy); % 残差平方和
SSR=(yy-Y_mean)'*(yy-Y_mean); % 回归方程变异平方和
SST=(YY-Y_mean)'*(YY-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R2=sqrt(SSR/SST); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好
v=[];
for j=1:mm
    SSEE(j)=(YY-(yy-b(j+1)*XX(:,j)))'*(YY-(yy-b(j+1)*XX(:,j)));
    v(j)=sqrt(1-SSE/SSEE(j));  %求得偏相关系数
end
disp(['偏相关系数为：' num2str(v)])

disp(['多元线性回归误差均方根:' num2str(sqrt(SSE/(n)))])

disp(['多元线性回归误差最大绝对值：' num2str(max(abs(YY-yy)))])


%*************** F检验 ******************
F=(SSR/p)/(SSE/(n-p-1)); % 服从F分布，F的值越大越好
if F > finv(alpha,p,n-p-1); % H=1，线性回归方程显著(好)；H=0，回归不显著
    disp('b不显著为0，回归方程通过F检验');
else
    disp('b显著为0，回归方程没有通过F检验');
end


%************* t检验 ****************
X=X(:,2:end);b=b(2:end);%去除b0项
S=sqrt(diag(inv(X'*X))*SSE/(n-p-1)); % 服从χ2(n-p-1)分布
t=b./S; % 服从T分布，绝对值越大线性关系显著
tInv=tinv(0.5+alpha/2,n-p-1);
tH=abs(t)>tInv; % H(i)=1，表示Xi对Y显著的线性作用；H(i)=0，Xi对Y的线性作用不明显
disp('各变量的t检验结果，1表示通过，0表示没通过');
disp(tH');
% 回归系数区间估计
tW=[-S,S]*tInv; % 接受H0，也就是说如果在beta_hat(i)对应区间中，那么Xi与Y线性作用不明显