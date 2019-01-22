
clc;clear;close all;

x=[2 4 0 3 1 5 6 7 8 9;2 6 7 22 5 15 4 9 8 1;5 8 12 9 0 11 30 7 6 4;5 4 9 0 0.2 2 7 6 3 1]';
% x=[2 4 0 3 1 5 6 7 8 9]';
y=[1 -1 1 -1 1 -1 1 1 1 -1]';

ERR=0.08;%最大训练误差
ECHO=100;%最大训练循环次数

[ CUT ] = adaboost_model( x,y ,ERR,ECHO);%训练

[ Y  ] = adaboost_pre( x, CUT );%预测


%计算分类错误率
a=Y>0;
b=y>0;
p_err=sum(abs(a-b))/size(x,1);

disp(CUT);
disp(p_err);