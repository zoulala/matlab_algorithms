%逻辑回归
%参考：http://blog.csdn.net/hechenghai/article/details/46817031

clear; close all; clc;
 x = [60 70
     65 75
     80 90
     70 60
     55 85
     78 57
     60 61
     90 95
     50 90
     75 58
     80 80
     65 72
     93 84
     74 69
     81 73
     40 38
     51 41
     39 68
     49 62
     51 39
     58 57
     60 53
     30 90
     70 40
     20 30
     40 86
     90 40
     55 72
     79 48
     42 85]; %每一行是一个样本
 y = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
 alpha=0.6;
 echo=500;
 figure_flag=1;
 
 
 [ w,x_mean,x_std ] = LR_model( x,y,alpha,echo,figure_flag );
 y_pre= LR_pre(x,w,x_mean,x_std);
 
 y_pre(y_pre>=0.5)=1;
 y_pre(y_pre<0.5)=0;
 
 
 
 
 