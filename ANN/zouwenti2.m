clear all;clc; 
  
 X = [0:0.1:10]; 
 T=sin(X);
  
 net =newff(minmax(X),[10,1],{'tansig','purelin'},'traingdm');
net.trainParam.epochs = 2000; %训练迭代次数
net.trainParam.goal = 1e-8;   %最小均方误差
net.trainParam.min_grad = 1e-20; %最小梯度
 net=train(net,X,T);
 x1 = [5:0.1:20]; 
 Y1 = sim(net,x1); 
 %T2 = sim(net,X); 
  
 figure(1); 
 plot(X,T,'b*',x1,Y1,'r+'); 
 
 %%问题：测试样本值大小超出了训练样本值大小，则无法输出正确的数据，即无法预测。。网络输出的是与该测试样本最近的训练样本的结果。
 %%所以，解决方法：训练样本应该覆盖所用的样本空间。。