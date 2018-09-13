%****************多元线性回归工具使用*******************

clc;clear;close all;
[num,TXT,raw]=xlsread('C:\Users\Administrator\Desktop\本科毕业设计数据.xlsx','sheet1');
num(:,1)=[];
% num=zscore(num)

for i=1:size(num,2)
  
    num(:,i)=(num(:,i)-min(num(:,i)))/(max(num(:,i))-min(num(:,i)));
   
end

% num=mapminmax(num(:,1))
x=num(1:end,1:end-1);
y=num(1:end,end);
lb=[-1000,-1000,0,-1000,-1000,0];
hb=[0,0,1000,0,0,1000];
b=lsqlin(x,y);%[],[] ,[] ,[] ,lb,hb)
yy=x*b;

figure;
plot(yy,'r.-');
hold on
plot(y,'b.-');
hold off;

disp(b');
