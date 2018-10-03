clear all;              %清除所有变量
clc;                    %清屏
format long;            %将数据显示为长整形科学计数
%------给定初始条条件------------------
N=40;                   %初始化群体个数
D=10;                   %初始化群体维数
T=100;                 %初始化群体最迭代次数
c11=2;                   %学习因子1
c21=2;                   %学习因子2
c12=1.5;
c22=1.5;
w=1.2;                  %惯性权重
eps=10^(-6);            %设置精度（在已知最小值的时候用）
%------初始化种群个体（限定位置和速度）------------
x=zeros(N,D);
v=zeros(N,D);
for i=1:N
    for j=1:D
        x(i,j)=randn;   %随机初始化位置
        v(i,j)=randn;   %随机初始化速度
    end
end
%------初始化种群个体（在此限定速度和位置）------------
x1=x;
v1=v;
%------初始化个体最优位置和最优值---
p1=x1;
pbest1=ones(N,1);
for i=1:N
    pbest1(i)=fitness(x1(i,:),D);
end
%------初始化全局最优位置和最优值---------------
g1=1000*ones(1,D);
gbest1=1000;
for i=1:N
    if(pbest1(i)<gbest1)
        g1=p1(i,:);
        gbest1=pbest1(i);
    end
end
gb1=ones(1,T);
%-----浸入主循环，按照公式依次迭代直到满足精度或者迭代次数---
for i=1:T
    for j=1:N
        if (fitness(x1(j,:),D)<pbest1(j))
            p1(j,:)=x1(j,:);
            pbest1(j)=fitness(x1(j,:),D);
        end
        if(pbest1(j)<gbest1)
            g1=p1(j,:);
            gbest1=pbest1(j);
        end
        v1(j,:)=w*v1(j,:)+c11*rand*(p1(j,:)-x1(j,:))+c21*rand*(g1-x1(j,:));
        x1(j,:)=x1(j,:)+v1(j,:);       
    end
    gb1(i)=gbest1;
end
plot(gb1)
TempStr=sprintf('c1= %g ,c2=%g',c11,c21);
title(TempStr);
xlabel('迭代次数');
ylabel('适应度值');

disp('*************************************************************')
disp('函数的全局最优位置为：')
Solution=g1
disp('最后得到的优化极值为：')
Result=fitness(g1,D)
disp('*************************************************************')

