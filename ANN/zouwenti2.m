clear all;clc; 
  
 X = [0:0.1:10]; 
 T=sin(X);
  
 net =newff(minmax(X),[10,1],{'tansig','purelin'},'traingdm');
net.trainParam.epochs = 2000; %ѵ����������
net.trainParam.goal = 1e-8;   %��С�������
net.trainParam.min_grad = 1e-20; %��С�ݶ�
 net=train(net,X,T);
 x1 = [5:0.1:20]; 
 Y1 = sim(net,x1); 
 %T2 = sim(net,X); 
  
 figure(1); 
 plot(X,T,'b*',x1,Y1,'r+'); 
 
 %%���⣺��������ֵ��С������ѵ������ֵ��С�����޷������ȷ�����ݣ����޷�Ԥ�⡣���������������ò������������ѵ�������Ľ����
 %%���ԣ����������ѵ������Ӧ�ø������õ������ռ䡣��