%%%%%%%%%%%%%%%%%%%%%%%%%%多元回归+检验分析，程序实现%%%%%%%%%%%%%%%%%%%%
                   %另有工具函数b=lsqlin(x,y)；（没有零点）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*******************首先读取数据*****************
clc;clear;close all;
[num1,TXT1,raw1]=xlsread('data\本科毕业设计数据.xlsx','sheet1');
[num2,TXT2,raw2]=xlsread('data\血糖检测数据_20150930.xlsx','sheet1');
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

%******** 显示初始数据 *******************
% num=num2;
% figure;
% subplot(211);plot(num(:,end));title('145组化验数据（num）');
% subplot(212);plot(num(:,1:end-1));title('红外数据');
% legend('470nm','660nm','730nm','850nm','940nm');

%********  数据分组 （高浓度数据放一组，低浓度数据为一组）****************
h_n=find(num(:,end)>9);
l_n=find(num(:,end)<=9);
h_num=num(h_n,:);
l_num=num(l_n,:);

num=h_num;

[n,m]=size(num);
y=num(:,m);
x=num(:,1:m-1);
bb=lsqlin(x,y);
disp(bb');
a=corrcoef(x);%分析相关系数

%*******************************************
%***************多元回归分析*****************

X=[ones(n,1),x];%训练数据
Y=y;%

b=(X'*X)\X'*Y;%回归系数
disp('回归系数：');
disp(b');
y1=X*b;%拟合值
figure;
plot(y,'b.-');title('多元线性回归(高浓度)');
hold on
plot(y1,'r.-');
hold off;
legend('real value','prediction of MLR');
%************************************************************************
%***************  离差和参数计算   *********************
e=Y-y1;
Y_mean=mean(Y);
SSE=(Y-y1)'*(Y-y1); % 残差平方和
SSR=(y1-Y_mean)'*(y1-Y_mean); % 回归方程变异平方和
SST=(Y-Y_mean)'*(Y-Y_mean); % 原数据Y总变异平方和，且满足SST=SSR+SSE
R2=sqrt(SSR/SST); % 复相关系数（复测定系数），表征回归离差占总离差的百分比，拟合程度，越大越好
v=[];
disp('复相关系数：')
disp(R2)
for j=1:m-1
    SSEE(j)=(Y-(y1-b(j+1)*X(:,j)))'*(Y-(y1-b(j+1)*X(:,j)));
    v(j)=sqrt(1-SSE/SSEE(j));  %求得偏相关系数
end
disp('偏相关系数为：')
disp(v);

disp('多元线性回归误差均方根:')
disp(sqrt(SSE/(n)));
disp('多元线性回归误差平均值：')
disp(sum(abs(e))/n);
disp('多元线性回归误差最大绝对值：')
disp(max(abs(Y-y1)));
disp('多元线性回归相对误差平均值：')
disp(sum(abs(e)./Y*100)/n);

figure;
hf=abs(e)./Y*100;
plot(hf,'.-');title('MLR相对误差曲线%');
figure;
hist(hf);xlabel('相对误差大小');ylabel('占%');title('MLR-相对误差直方图');%相对误差直方图
%*************************************************************************
%*************** F检验 ******************
p=m-1;
alpha=0.95;
F=(SSR/p)/(SSE/(n-p-1)) ;% 服从F分布，F的值越大越好
disp('F检验值:');
disp(F)
if F > finv(alpha,p,n-p-1); % H=1，线性回归方程显著(好)；H=0，回归不显著
    disp('b不显著为0，回归方程通过F检验');
else
    disp('b显著为0，回归方程没有通过F检验');
end


%************* t检验 ****************
X=X(:,2:end);b=b(2:end);%去除b0项
S=sqrt(diag(inv(X'*X))*SSE/(n-p-1)); % 服从χ2(n-p-1)分布
t=b./S; % 服从T分布，绝对值越大线性关系显著
disp('t检验值：');
disp(t');
tInv=tinv(0.5+alpha/2,n-p-1);
tH=abs(t)>tInv; % H(i)=1，表示Xi对Y显著的线性作用；H(i)=0，Xi对Y的线性作用不明显
disp('各变量的t检验结果，1表示通过，0表示没通过');
disp(tH');
% 回归系数区间估计
tW=[-S,S]*tInv; % 接受H0，也就是说如果在beta_hat(i)对应区间中，那么Xi与Y线性作用不明显
if prod(abs(tH))==0 %累乘
   pp=find(abs(t)==min(abs(t)));
   %%num(:,pp+1)=[];
   disp('将要被剔除的变量位置是：');
   disp(pp);
%elseif prod(abs(tH))==1
end




