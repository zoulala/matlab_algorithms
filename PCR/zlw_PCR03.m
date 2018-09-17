%******* P-PCR 多项式主元回归 程序 ****************
%说明：对主元采用二次型形式（t1,t2,t1^2,t2^2,t1*t2）扩展，另外程序中注释了另外两种对该二次型矩阵降维选择变量的方法（1、PCA二次降维，2、逐步回归选择变量）
%作者：zlw
%时间：2015-10-13

%*************** 数据预处理 ****************
clc;clear;close all;
[num1,TXT1,raw1]=xlsread('C:\Users\Administrator\Desktop\本科毕业设计数据.xlsx','sheet1');
[num2,TXT2,raw2]=xlsread('C:\Users\Administrator\Desktop\血糖检测数据_20150930.xlsx','sheet1');
num1(:,1)=[];
num2(:,1)=[];
zz=find(isnan(num2(:,1)));%去除nan无效数据行
num2(zz,:)=[];

num=[num1;num2];
% num(:,[1,end-1])=[];
% 
%********  数据分组 （高浓度数据放一组，低浓度数据为一组）****************
h_n=find(num(:,end)>9);
l_n=find(num(:,end)<=9);
h_num=num(h_n,:);
l_num=num(l_n,:);

num=h_num;

%************ 主成分分析  ******************************
con=0.9;%累计贡献率
[n,m]=size(num);
y=num(:,m);
x=num(:,1:m-1);

X=zscore(x); %数据标准化
%数据归一化  或再标准化
% [n,~]=size(x);
% x_2=sqrt(diag(x*x'));
% for i=1:n
%     X(i,:)=x(i,:)/x_2(i);
% end
% X=zscore(X);

Y=zscore(y);
[u,s,v] = svds(X);

X_cov=cov(X); %计算协方差
[L, K]=eig(X_cov); %计算特征值K、特征向量T
K=eig(K);
Ksum=sum(K);
mm=size(K,1);
Ssum=0;
for i=1:mm
    Ssum=Ssum+K(mm-i+1);
    if Ssum/Ksum>=con
        a=i;
        disp(a);
        break;
    end
end
for i=1:mm
    M(i)=K(mm-i+1);
    N(1:mm,i)=L(1:mm,mm-i+1);
end
%KL=diag(M);
P=N(:,1:a);
T=X*P;

%********* 对主元进行多项式扩展 **********
TT(:,1:a)=T;
TT(:,a+1:2*a)=T.^2;
k=2*a+1;
for i=1:a-1
    for j=i+1:a
        TT(:,k)=diag(T(:,i)*T(:,j)');
        k=k+1;
    end
end
%****************************************
% 
%************** 对扩展矩阵再次进行主元提取 **********************
% TT_cov=cov(TT); %计算协方差
% [LT, KT]=eig(TT_cov); %计算特征值K、特征向量T
% KT=eig(KT);
% Ksum=sum(KT);
% mT=size(KT,1);
% Ssum=0;
% for i=1:mT
%     Ssum=Ssum+KT(mT-i+1);
%     if Ssum/Ksum>=con
%         r=i;
%         disp(r);
%         break;
%     end
% end
% for i=1:mT
%     MT(i)=KT(mT-i+1);
%     NT(1:mT,i)=LT(1:mT,mT-i+1);
% end
% %KL=diag(M);
% PT=NT(:,1:r);
% TR=TT*PT;
% bT=Y'*TR/(TR'*TR);%对多项式主元二次主元的回归系数
% YT=TR*bT';
% yT=YT*std(y)+mean(y);%反标准化
% figure;
% plot(y);title('多项式二次主元回归');
% hold on;
% plot(yT);legend('real value','prediction of PP-PCR');
% hold off;
% 
% %*************** 计算误差 ****************
% e=y-yT;
% disp('均方根误差：')
% disp(sqrt(e'*e/n));
% disp('误差平均值：')
% disp(sum(abs(e))/n);
% disp('误差最大值');
% disp(max(abs(e)));
% disp('相对误差');
% disp(abs(e./y*100));
% disp('相对误差最大值');
% disp(max(abs(e./y*100)));
% disp('相对误差平均值');
% disp(mean(abs(e./y*100)));
% 
% figure;
% hist(abs(e./y*100));title('相对误差直方图'); 
% disp('******************************************************************');


%*************** 逐步回归选取多项式扩展矩阵主元 ***********************
PZ=[TT,Y];
IN=zbhg(PZ);
TTN=TT(:,IN);
bTN=Y'*TTN/(TTN'*TTN);%对多项式主元二次主元的回归系数
YTN=TTN*bTN';
yTN=YTN*std(y)+mean(y);%反标准化
figure;
plot(y);title('逐步多项式主元回归');
hold on;
plot(yTN);legend('real value','prediction of SWP-PCR');
hold off;


%*************** 计算误差 ****************
e=y-yTN;
disp('均方根误差：')
disp(sqrt(e'*e/n));
disp('误差平均值：')
disp(sum(abs(e))/n);
disp('误差最大值');
disp(max(abs(e)));
disp('相对误差');
disp(abs(e./y*100));
disp('相对误差最大值');
disp(max(abs(e./y*100)));
disp('相对误差平均值');
disp(mean(abs(e./y*100)));

figure;
plot(abs(e./y*100));
figure;
hist(abs(e./y*100));title('SWP-PCR-相对误差直方图'); axis([0 40 0 25]);
disp('************************ 以下p-pcr******************************************');



b=Y'*TT/(TT'*TT);%对多项式主元的回归系数

YY=TT*b';%标准化拟合值
yy=YY*std(y)+mean(y);%反标准化
%******************** 画图 ************************
figure;
plot(y);title('多项式主元回归');
hold on;
plot(yy);legend('real value','prediction of P-PCR');
hold off;

%*************** 计算误差 ****************
e=y-yy;
disp('均方根误差：')
disp(sqrt(e'*e/n));
disp('误差平均值：')
disp(sum(abs(e))/n);
disp('误差最大值');
disp(max(abs(e)));
disp('相对误差');
disp(abs(e./y*100));
disp('相对误差最大值');
disp(max(abs(e./y*100)));
disp('相对误差平均值');
disp(mean(abs(e./y*100)));

figure;
hist(abs(e./y*100));title('P-PCR-相对误差直方图'); 
axis([0 40 0 25]);









