% BP 神经网络用于模式分类 
% 使用平台 - Matlab6.5 
 
clc 
clear 
close all 
 
%--------------------------------------------------- 
% 产生训练样本与测试样本，每一列为一个样本 
 
trnx = [rand(3,5),rand(3,5)+1,rand(3,5)+2];% 训练样本 
trny= [repmat([1;0;0],1,5),repmat([0;1;0],1,5),repmat([0;0;1],1,5)];% 训练目标 
 
tstx = [rand(3,5),rand(3,5)+1,rand(3,5)+2]; % 测试样本 
tsty = [repmat([1;0;0],1,5),repmat([0;1;0],1,5),repmat([0;0;1],1,5)]; % 测试目标 
%--------------------------------------------------- 
% 函数接口赋值 
 
NodeNum = 30;           % 隐层节点数  
TypeNum = 3;            % 输出维数 
Epochs = 1000;          % 训练次数 
%--------------------------------------------------- 
% 设置网络参数 
%TF1 = 'tansig';TF2 = 'purelin'; % 缺省值 
%TF1 = 'tansig';TF2 = 'logsig'; 
TF1 = 'logsig';TF2 = 'purelin'; 
%TF1 = 'tansig';TF2 = 'tansig'; 
%TF1 = 'logsig';TF2 = 'logsig'; 
%TF1 = 'purelin';TF2 = 'purelin'; 
 
net = newff(minmax(trnx),[NodeNum TypeNum],{TF1 TF2},'trainlm'); 
 
% 指定训练参数 
%net.trainFcn = 'trainlm';  % 内存使用最多（快） 
%net.trainFcn = 'trainbfg'; 
%net.trainFcn = 'trainrp';  % 内存使用最少（慢） 
%net.trainFcn = 'traingda'; % 变学习率 
%net.trainFcn = 'traingdx'; 
 
net.trainParam.epochs = Epochs;     % 最大训练次数 
net.trainParam.goal = 1e-8;         % 最小均方误差 
net.trainParam.min_grad = 1e-20;    % 最小梯度 
net.trainParam.show = 200;          % 训练显示间隔 
net.trainParam.time = inf;          % 最大训练时间 
 
%--------------------------------------------------- 
% 训练与测试 
 
net = train(net,trnx,trny);             % 训练 
X = sim(net,tstx);                     % 测试 - 输出为预测值 
X = full(compet(X))                 % 竞争输出 
 
%--------------------------------------------------- 
% 结果统计 
Result = ~sum(abs(X-tsty))               % 正确分类显示为1 
Percent = sum(Result)/length(Result)   % 正确分类率