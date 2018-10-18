clc;clear all;close all;
[num1,TXT1,raw1]=xlsread('C:\Users\Administrator\Desktop\本科毕业设计数据.xlsx','sheet1');
[num2,TXT2,raw2]=xlsread('C:\Users\Administrator\Desktop\血糖检测数据_20150930.xlsx','sheet1');
num1(:,1)=[];
num2(:,1)=[];
zz=find(isnan(num2(:,1)));%去除nan无效数据行
num2(zz,:)=[];

num=[num1;num2];

%********  数据分组 （高浓度数据放一组，低浓度数据为一组）****************
h_n=find(num(:,end)>9);
l_n=find(num(:,end)<=9);
h_num=num(h_n,:);
l_num=num(l_n,:);


num=h_num;%num=l_num;
%********************* 初始化 及参数 ****************************
[n,m]=size(num);

x=num(:,1:end-1);
y=num(:,end);

%********************** 初始化 和 参数 ******************************
n_train=[1:2:n];%训练样本点
n_test=[2:2:n];%预测样本点
x_train=x(n_train,:);y_train=y(n_train,:);%训练数据
x_test=x(n_test,:);%预测输入数据；

r=3;
con=0.9;%主元累计贡献率
r_pls=3;%pls选取成分个数
%************** osc数据处理 ***********************

[p,w,X_train ] = osc1_mod( x_train,y_train,r);
% [p,w,X_train ] = osc2_mod( x_train,y_train,r);

X_test  = osc_pr( x_test,p,w );

%*************** 多元线性回归 ****************
b=(X_train'*X_train)\X_train'*y_train;%回归系数
y_mlr=x_test*b;

%***************　pcr建模和预测　****************
[P,X_mean,X_std,Y_mean,Y_std,b]= pcr_mod( X_train,y_train,con );%建立pcr模型

y_pcr = pcr_pr( X_test,P,X_mean,X_std,Y_mean,Y_std,b);%预测新数据

%*************** pls建模和预测 *************
[p,X_mean,X_std,Y_mean,Y_std,b]= pls_mod( X_train,y_train,r_pls );%建立pls模型

y_pls = pls_pr( X_test,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%预测新数据

%******************** p_pcr建模和预测 ********************************
[P,X_mean,X_std,Y_mean,Y_std,b,r]= p_pcr_mod( X_train,y_train,con );%建立p_pcr模型

y_p_pcr = p_pcr_pr( X_test,P,X_mean,X_std,Y_mean,Y_std,b,r);%预测新数据

%******************** p_pls建模和预测 ********************************
[p,X_mean,X_std,Y_mean,Y_std,b]= p_pls_mod( X_train,y_train,r_pls );%建立p_pls模型

y_p_pls = p_pls_pr( X_test,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%预测新数据

%******************** 误差 ************************
k=length(n_test);
err_mlr=sum(abs(y(n_test)-y_mlr)./y(n_test)*100)/k
err_pcr=sum(abs(y(n_test)-y_pcr)./y(n_test)*100)/k
err_pls=sum(abs(y(n_test)-y_pls)./y(n_test)*100)/k
err_p_pcr=sum(abs(y(n_test)-y_p_pcr)./y(n_test)*100)/k
err_p_pls=sum(abs(y(n_test)-y_p_pls)./y(n_test)*100)/k
    

%******************** 画图 ************************
figure;
plot(y_mlr);
hold on;
plot(y_pcr);
hold on;
plot(y_pls);
hold on;
plot(y_p_pcr);
hold on;
plot(y_p_pls);
hold on
plot(y(n_test),'b.-');
title('预测曲线');
legend('mlr预测','pcr预测','pls预测','p-pcr预测','p-pls预测','y真值');
