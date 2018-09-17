%****************主元回归  （泛化）*******************
%带有预测功能

clc;clear;close all;
[num1,TXT1,raw1]=xlsread('C:\Users\Administrator\Desktop\本科毕业设计数据.xlsx','sheet1');
[num2,TXT2,raw2]=xlsread('C:\Users\Administrator\Desktop\血糖检测数据_20150930.xlsx','sheet1');
num1(:,1)=[];
num2(:,1)=[];
zz=find(isnan(num2(:,1)));%去除nan无效数据行
num2(zz,:)=[];

% for i=1:5:size(num2,1)
%     num2v((i-1)/5+1,:)=mean(num2(i:i+4,:));%取平均值（若用均值建模）
% end
% num2=num2v;

num=[num1;num2];
%num=num2;

[n,m]=size(num);
y=num(:,m);
x=num(:,1:m-1);
n1=round(n/3*2);%训练数据量
n2=round(n/3);%测试数据量
x1=x(1:n1,:);
x2=x(n1+1:n,:);

X=x1;
X_T=x2;
% X=[ones(m,1),X];
Y=y(1:n1);%训练数据
Y_T=y(n1+1:n);%测试数据
con=0.9;

%标准化、再求协方差矩阵
[nn,m]=size(X);
for j=1:m
    x(j)=mean(X(:,j));
    s(j)=sqrt(cov(X(:,j)));
end
for i=1:nn
    for j=1:m
        Y1(i,j)=(X(i,j)-x(j))/s(j);
    end
end

%X_te=load('C:\Documents and Settings\Administrator\桌面\d05_te.dat');
%故障数据标准化
% [n1,m1]=size(X_te);
% for j=1:m1
%     x1(j)=mean(X_te(:,j));
%     s1(j)=sqrt(cov(X_te(:,j)));
% end
% for i=1:n1
%     for j=1:m1
%         Y(i,j)=(X_te(i,j)-x(j))/s(j);
%     end
% end
YY=Y1;
RY=cov(YY);%协方差
%特征值分解
[T,K]=eig(RY);
%计算累计贡献率提取主元
S=eig(full(K));
Ksum=sum(sum(K,2),1);
Ssum=0;
for i=1:size(S,1)
    Ssum=Ssum+S(m-i+1);
    if Ssum/Ksum>=con
        a=i;
        disp(a);
        break;
    end
end
for i=1:m
    M(i)=S(m-i+1);
    N(1:m,i)=T(1:m,m-i+1);
end
KL=diag(M);
eig(full(KL));
P=N(:,1:a);%..............,,,前a个特征向量矩阵
Ka=KL(1:a,1:a);%。。。。。。。。。前a个特征根对角矩阵

T=X*P;%主元
b=inv(T'*T)*T'*Y;%对主元的回归系数
Q=P*b;%对原始变量的参数
disp(Q');
y=X*Q;%拟合值
y_t=X_T*Q;%泛化值
e=Y-y;%拟合误差
figure;
plot(e,'b.-');
legend('PCR误差曲线');


Y_mean=mean(Y);
SSE=e'*e ;% 残差平方和
SSR=(y-Y_mean)'*(y-Y_mean); % 回归方程变异平方和
SST=(Y-Y_mean)'*(Y-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R2=sqrt(1-SSE/SST); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好

R2

ess=sqrt((e'*e)/n);%拟合误差的均方根
emax=max(abs(e));%误差最大值
%**************************************************************************
%*******带有零点的主元回归计算*******************
TT=Y1*P;%主元
Y2=zscore(Y);
bb=inv(TT'*TT)*TT'*Y2;%对主元的回归系数
QQ=P*bb;%对标准化变量的参数
B=[mean(Y)-std(Y)*(mean(X)./std(X))*QQ,std(Y)*QQ'./std(X)];
XX=[ones(size(X,1),1),X];
XX_T=[ones(size(X_T,1),1),X_T];
yyy=XX*B';%%%%%这段是带常数项系数的。拟合
yyy_t=XX_T*B';%泛化
ee=Y-yyy;
e_t=Y_T-yyy_t;
eess=sqrt(ee'*ee/n);
SSR1=(yyy-Y_mean)'*(yyy-Y_mean); % 回归方程变异平方和
SST1=(Y-Y_mean)'*(Y-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R12=sqrt(SSR1/SST1); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好
R12

figure;
plot(num(:,end),'b.-');
hold on;
plot(yyy,'r.-');
hold on;
plot((n1+1):n,yyy_t,'g.-');
xlabel('sample number');ylabel('因变量');title('PCA回归分析(num)');
hold off;
% legend('real value','prediction of PCR','prediction of PCR(b0)');
legend('real value','fitting of PCR','prediction of PCR');
disp('回归系数：')
disp(B);
disp('主元回归误差均方根:')
disp(eess);
disp('主元回归误差平均值：')
disp(sum(abs(ee))/n);
disp('主元回归误差最大绝对值：')
disp(max(abs(ee)));
disp('主元回归相对误差平均值：')
disp(sum(abs(ee)./Y*100)/n);

disp(sqrt(e_t'*e_t/n2));
disp(sum(abs(e_t))/n2);
disp(max(abs(e_t)));
disp(sum(abs(e_t)./Y_T*100)/n2);

%*******************************降为2维图分析**********************

P=N(:,1:2);%..............,,,前a个特征向量矩阵
T=Y1*P;%主元

figure;
plot(T(:,1),T(:,2),'b.');title('选取两个主元-二维图');
hold on;
plot(T(1:3,1),T(1:3,2),'ro');
hold on;
plot(T([6,11:20],1),T([6,11:20],2),'gv');
hold off;
legend('normal','high','low');

