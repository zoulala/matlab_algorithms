
clc;clear;close all;

x=[2 4 0 3 1 5 6 7 8 9;2 6 7 22 5 15 4 9 8 1;5 8 12 9 0 11 30 7 6 4;5 4 9 0 0.2 2 7 6 3 1]';
% x=[2 4 0 3 1 5 6 7 8 9]';
y=[1 -1 1 -1 1 -1 1 1 1 -1]';

ERR=0.08;%���ѵ�����
ECHO=100;%���ѵ��ѭ������

[ CUT ] = adaboost_model( x,y ,ERR,ECHO);%ѵ��

[ Y  ] = adaboost_pre( x, CUT );%Ԥ��


%������������
a=Y>0;
b=y>0;
p_err=sum(abs(a-b))/size(x,1);

disp(CUT);
disp(p_err);