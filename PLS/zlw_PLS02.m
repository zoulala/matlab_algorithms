%*********************** pls 回归分析 (泛化)*************************

%*************调用pls0函数************
%************注意：在只有1个因变量时，pls和pcr还是不相同的

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
% num=num2;
[n,m]=size(num);
n1=round(n/3*2);%训练数据量
n2=round(n/3);%测试数据量

x=num(1:n1,1:end-1);%训练
y=num(1:n1,end);
X=num(n1+1:end,1:end-1);%泛化
Y=num(n1+1:end,end);
[xnn,xmm]=size(X);
[xn,xm]=size(x);
pz=[x,y];
sol=pls0(pz,xm,1);
disp('');
disp('PLS回归系数：');
disp(vpa(sol',4));
figure;
plot(num(1:end,end),'b.-');
hold on;
[row,col]=size(pz);
X0=[ones(xn,1),x];
X=[ones(xnn,1),X];
y0=X0*sol;
yy=X*sol;
t0=1:xn;t1=n1+1:n;
plot(t0,y0,'r.-');xlabel('sample number');ylabel('因变量');title('PLS回归分析(num)');
hold on;
plot(t1,yy,'g.-');
hold off;
legend('real value','fitting of PLS','prediction of PLS');

e=Y-yy;
% figure;
% plot(e,'b.-');
% legend('PLS误差曲线');
% axis([0 500 -20 20]);
Y_mean=mean(Y);
SSE=(Y-yy)'*(Y-yy) ;% 残差平方和
SSR=(yy-Y_mean)'*(yy-Y_mean); % 回归方程变异平方和
SST=(Y-Y_mean)'*(Y-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R2=sqrt(SSR/SST); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好
disp('复相关系数：')
disp(R2)
disp('PLS回归误差均方根:')
disp(sqrt(SSE/(n2)));
disp('PLS回归误差平均值：')
disp(sum(abs(e))/n2);
disp('PLS回归误差最大绝对值：')
disp(max(abs(Y-yy)));
disp('PLS回归相对误差平均值：')
disp(sum(abs(e)./Y*100)/n2);

Xt=x(:,1:end);bt=sol(2:end);%去除b0项
St=sqrt(diag(inv(Xt'*Xt))*SSE/(row-xm-1)); % 服从χ2(n-p-1)分布
tt=bt./St; % 服从T分布，绝对值越大线性关系显著
disp('t检验值：');
disp(tt');