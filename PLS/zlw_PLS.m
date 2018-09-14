%*********************** pls 回归分析 *************************

%*************调用pls函数************
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
% num(:,[1,end-1])=[];

%********  数据分组 （高浓度数据放一组，低浓度数据为一组）****************
h_n=find(num(:,end)>9);
l_n=find(num(:,end)<=9);
h_num=num(h_n,:);
l_num=num(l_n,:);

num=l_num;

%*******************************************************************
[n,m]=size(num);

x=num(:,1:end-1);%训练
y=num(:,end);
[xn,xm]=size(x);
pz=[x,y];
%*************************************************************
% LV=3;%提取成分个数
% [B b]=plskernel_1(x,y,LV);%pls另一种解法，B系数，b常数项
% b
% B
%*************************************************************
sol=pls(x,y,2);
disp('');
disp('PLS回归系数：');
disp(vpa(sol',4));
figure;
plot(num(1:end,end),'b.-');
hold on;
[row,col]=size(pz);
X0=[ones(xn,1),x];
y0=X0*sol;
t0=1:xn;
plot(t0,y0,'r.-');xlabel('sample number');ylabel('因变量');title('PLS回归分析(高浓度)');
hold off;
legend('real value','prediction of PLS');

e=y-y0;
% figure;
% plot(e,'b.-');
% legend('PLS误差曲线');
% axis([0 500 -20 20]);
Y_mean=mean(y);
SSE=(y-y0)'*(y-y0) ;% 残差平方和
SSR=(y0-Y_mean)'*(y0-Y_mean); % 回归方程变异平方和
SST=(y-Y_mean)'*(y-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R2=sqrt(SSR/SST); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好
disp('复相关系数：')
disp(R2)
disp('PLS回归误差均方根:')
disp(sqrt(SSE/(n)));
disp('PLS回归误差平均值：')
disp(sum(abs(e))/n);
disp('PLS回归误差最大绝对值：')
disp(max(abs(y-y0)));
disp('PLS回归相对误差平均值：')
disp(sum(abs(e)./y*100)/n);
disp('PLS回归相对误差最大值：')
disp(max(abs(e)./y*100));
hf=abs(e)./y*100;
figure;
plot(hf,'.-');title('PLS相对误差曲线%');
figure;
hist(hf);xlabel('相对误差大小');ylabel('占%');title('PLS-相对误差直方图');%相对误差直方图
axis([0 45 0 20]);

Xt=x(:,1:end);bt=sol(2:end);%去除b0项
St=sqrt(diag(inv(Xt'*Xt))*SSE/(row-xm-1)); % 服从χ2(n-p-1)分布
tt=bt./St; % 服从T分布，绝对值越大线性关系显著
disp('t检验值：');
disp(tt');