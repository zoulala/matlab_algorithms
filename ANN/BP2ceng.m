% BP 神经网络用于预测
% 使用平台 - Matlab7.0
% 数据为1986年到2000年的交通量 ，网络为3输入，1输出
% 15组数据，其中9组为正常训练数据，3组为变量数据，3组为测试数据
%by akjuan
%all rights preserved by www.4math.cn
%2008.11

clc
clear

%---------------------------------------------------
%原始数据
%---------------------------------------------------
year=1986:2000;%数据是从1986到2000年的

p=[493 372 445;372 445 176;445 176 235;176 235 378;235 378 429;...
378 429 561;429 561 651;561 651 467;651 467 527;467 527 668;...
527 668 841; 668 841 526;841 526 480;526 480 567;480 567 685]';%输入数据，共15组，每组3个输入
t=[176 235 378 429 561 651 467 527 668 841 526 480 567 685 507];%输出数据，共15组，每组1个输出


%---------------------------------------------------
%数据归一化处理
%mapminmax函数默认将数据归一化到[-1,1]，调用形式如下
%[y,ps] =%mapminmax(x,ymin,ymax)
%x需归化的数据输入
%ymin，ymax为需归化到的范围，不填默认为归化到[-1,1]
%y归一化后的样本数据
%ps处理设置，ps主要在结果反归一化中需要调用，或者使用同样的settings归一化另外一组数据
%---------------------------------------------------
[normInput,ps] = mapminmax(p);
[normTarget,ts] = mapminmax(t);


%---------------------------------------------------
%数据乱序，及分类处理
%将输入的15组数据的20%，即3组，用来作为测试数据；
% 样本的20%，即3组，用来作为变化数据；
%另外9组用来正常输入，用来训练；
%dividevec()用来重新随机抽取上述三种分类的数据，原来的顺序被打乱
%函数调用的语法
%[trainV,valV,testV] = dividevec(p,t,valPercent,testPercent)
%输入p为输入数据，t为输出数据
%valPercent为训练用的变化数据在总输入中的百分比
%testPercent为训练用的测试数据在总输入中的百分比
%输出trainV,valV,testV分别为按乱序及相应百分比，抽取得到的数据
%另外，打乱后的数据，p和t都是对应的，请放心使用
%---------------------------------------------------
testPercent = 0.20; % Adjust as desired
validatePercent = 0.20; % Adust as desired
[trainSamples,validateSamples,testSamples] = dividevec(normInput,normTarget,validatePercent,testPercent);


%---------------------------------------------------
% 设置网络参数
%--------------------------------------------------- 
NodeNum1 = 20; % 隐层第一层节点数
NodeNum2=40; % 隐层第二层节点数
TypeNum = 1; % 输出维数

TF1 = 'tansig';TF2 = 'tansig'; TF3 = 'tansig';%各层传输函数，TF3为输出层传输函数
%如果训练结果不理想，可以尝试更改传输函数，以下这些是各类传输函数
%TF1 = 'tansig';TF2 = 'logsig';
%TF1 = 'logsig';TF2 = 'purelin';
%TF1 = 'tansig';TF2 = 'tansig';
%TF1 = 'logsig';TF2 = 'logsig';
%TF1 = 'purelin';TF2 = 'purelin'; 

%注意创建BP网络函数newff()的参数调用，在新版本(7.6)中已改变
net=newff(minmax(normInput),[NodeNum1,NodeNum2,TypeNum],{TF1 TF2 TF3},'traingdx');%创建四层BP网络



%---------------------------------------------------
% 设置训练参数
%--------------------------------------------------- 
net.trainParam.epochs=10000;%训练次数设置
net.trainParam.goal=1e-6;%训练目标设置
net.trainParam.lr=0.01;%学习率设置,应设置为较少值，太大虽然会在开始加快收敛速度，但临近最佳点时，会产生动荡，而致使无法收敛
%---------------------------------------------------
% 指定训练函数
%---------------------------------------------------
% net.trainFcn = 'traingd'; % 梯度下降算法
% net.trainFcn = 'traingdm'; % 动量梯度下降算法
%
% net.trainFcn = 'traingda'; % 变学习率梯度下降算法
% net.trainFcn = 'traingdx'; % 变学习率动量梯度下降算法
%
% (大型网络的首选算法)
% net.trainFcn = 'trainrp'; % RPROP(弹性BP)算法,内存需求最小
%
% (共轭梯度算法)
% net.trainFcn = 'traincgf'; % Fletcher-Reeves修正算法
% net.trainFcn = 'traincgp'; % Polak-Ribiere修正算法,内存需求比Fletcher-Reeves修正算法略大
% net.trainFcn = 'traincgb'; % Powell-Beal复位算法,内存需求比Polak-Ribiere修正算法略大
%
% (大型网络的首选算法)
%net.trainFcn = 'trainscg'; % Scaled Conjugate Gradient算法,内存需求与Fletcher-Reeves修正算法相同,计算量比上面三种算法都小很多
% net.trainFcn = 'trainbfg'; % Quasi-Newton Algorithms - BFGS Algorithm,计算量和内存需求均比共轭梯度算法大,但收敛比较快
% net.trainFcn = 'trainoss'; % One Step Secant Algorithm,计算量和内存需求均比BFGS算法小,比共轭梯度算法略大
%
% (中型网络的首选算法)
%net.trainFcn = 'trainlm'; % Levenberg-Marquardt算法,内存需求最大,收敛速度最快
% net.trainFcn = 'trainbr'; % 贝叶斯正则化算法
%
% 有代表性的五种算法为:'traingdx','trainrp','trainscg','trainoss', 'trainlm'

net.trainfcn='traingdm';
[net,tr] = train(net,trainSamples.P,trainSamples.T,[],[],validateSamples,testSamples);

%---------------------------------------------------
% 训练完成后，就可以调用sim()函数，进行仿真了
%--------------------------------------------------- 
[normTrainOutput,Pf,Af,E,trainPerf] = sim(net,trainSamples.P,[],[],trainSamples.T);%正常输入的9组p数据，BP得到的结果t
[normValidateOutput,Pf,Af,E,validatePerf] = sim(net,validateSamples.P,[],[],validateSamples.T);%用作变量3的数据p，BP得到的结果t
[normTestOutput,Pf,Af,E,testPerf] = sim(net,testSamples.P,[],[],testSamples.T);%用作测试的3组数据p，BP得到的结果t


%---------------------------------------------------
% 仿真后结果数据反归一化，如果需要预测，只需将预测的数据P填入
% 将获得预测结果t
%--------------------------------------------------- 
trainOutput = mapminmax('reverse',normTrainOutput,ts);%正常输入的9组p数据，BP得到的归一化后的结果t
trainInsect = mapminmax('reverse',trainSamples.T,ts);%正常输入的9组数据t
validateOutput = mapminmax('reverse',normValidateOutput,ts);%用作变量3的数据p，BP得到的归一化的结果t
validateInsect = mapminmax('reverse',validateSamples.T,ts);%用作变量3的数据t
testOutput = mapminmax('reverse',normTestOutput,ts);%用作变量3组数据p，BP得到的归一化的结果t
testInsect = mapminmax('reverse',testSamples.T,ts);%用作变量3组数据t


%---------------------------------------------------
% 数据分析和绘图
%--------------------------------------------------- 
figure
plot(1:12,[trainOutput validateOutput],'b-',1:12,[trainInsect validateInsect],'g--',13:15,testOutput,'m*',13:15,testInsect,'ro');
title('o为真实值，*为预测值')
xlabel('年份');
ylabel('交通量（辆次/昼夜）');