% BP ����������ģʽ���� 
% ʹ��ƽ̨ - Matlab6.5 
 
clc 
clear 
close all 
 
%--------------------------------------------------- 
% ����ѵ�����������������ÿһ��Ϊһ������ 
 
trnx = [rand(3,5),rand(3,5)+1,rand(3,5)+2];% ѵ������ 
trny= [repmat([1;0;0],1,5),repmat([0;1;0],1,5),repmat([0;0;1],1,5)];% ѵ��Ŀ�� 
 
tstx = [rand(3,5),rand(3,5)+1,rand(3,5)+2]; % �������� 
tsty = [repmat([1;0;0],1,5),repmat([0;1;0],1,5),repmat([0;0;1],1,5)]; % ����Ŀ�� 
%--------------------------------------------------- 
% �����ӿڸ�ֵ 
 
NodeNum = 30;           % ����ڵ���  
TypeNum = 3;            % ���ά�� 
Epochs = 1000;          % ѵ������ 
%--------------------------------------------------- 
% ����������� 
%TF1 = 'tansig';TF2 = 'purelin'; % ȱʡֵ 
%TF1 = 'tansig';TF2 = 'logsig'; 
TF1 = 'logsig';TF2 = 'purelin'; 
%TF1 = 'tansig';TF2 = 'tansig'; 
%TF1 = 'logsig';TF2 = 'logsig'; 
%TF1 = 'purelin';TF2 = 'purelin'; 
 
net = newff(minmax(trnx),[NodeNum TypeNum],{TF1 TF2},'trainlm'); 
 
% ָ��ѵ������ 
%net.trainFcn = 'trainlm';  % �ڴ�ʹ����ࣨ�죩 
%net.trainFcn = 'trainbfg'; 
%net.trainFcn = 'trainrp';  % �ڴ�ʹ�����٣����� 
%net.trainFcn = 'traingda'; % ��ѧϰ�� 
%net.trainFcn = 'traingdx'; 
 
net.trainParam.epochs = Epochs;     % ���ѵ������ 
net.trainParam.goal = 1e-8;         % ��С������� 
net.trainParam.min_grad = 1e-20;    % ��С�ݶ� 
net.trainParam.show = 200;          % ѵ����ʾ��� 
net.trainParam.time = inf;          % ���ѵ��ʱ�� 
 
%--------------------------------------------------- 
% ѵ������� 
 
net = train(net,trnx,trny);             % ѵ�� 
X = sim(net,tstx);                     % ���� - ���ΪԤ��ֵ 
X = full(compet(X))                 % ������� 
 
%--------------------------------------------------- 
% ���ͳ�� 
Result = ~sum(abs(X-tsty))               % ��ȷ������ʾΪ1 
Percent = sum(Result)/length(Result)   % ��ȷ������