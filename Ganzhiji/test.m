clc;clear;close all;

X=[3,3;4,3;1,1];
Y=[1;1;-1];

[W,b]=perceptron(X,Y,100);



sign=X*W+b; %¾ö²ßº¯Êý

sign(sign>0)=1;
sign(sign<0)=-1;

disp(sign);


