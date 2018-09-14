%%%********* 多项式偏最小二乘 程序实现 *****************
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

num=h_num;

%*******************************************************************
[n,m]=size(num);

x=num(:,1:end-1);%训练
y=num(:,end);
% [xn,xm]=size(x);
% pz=[x,y];
p_pls(x,y,3);