
clear all
clc
global X nn K_gram;
load E:\matlab\work\te.mat;
f0=A0(51:100,:);
f1=A1(201:250,:);
f2=A5(201:250,:);
f3=A7(201:250,:);

A1=f0;
 [n1,m1]=size(A1);
A2=f1;
 [n2,m2]=size(A2);
A3=f2;
 [n3,m3]=size(A3);
A4=f3;
 [n4,m4]=size(A4);
 
X=[A1;A2;A3;A4];
[nn,mm]=size(X);
K_gram=zeros(nn,nn);
K_gram(1:n1,1:n1)=ones(n1);
K_gram(n1+1:n1+n2,n1+1:n1+n2)=ones(n2);
K_gram(n1+n2+1:n1+n2+n3,n1+n2+1:n1+n2+n3)=ones(n3); 
K_gram(n1+n2+n3+1:n1+n2+n3+n4,n1+n2+n3+1:n1+n2+n3+n4)=ones(n4); 
X=zscore(X);



% n is the dimension of variable 粒子维数
% m is the number of particle 粒子个数
% x is a m*n matrix 粒子
% pbx is a m*n matrix 个体最优解
% v is a m*n matrix 速度
% gbx is 1*n matrix 全局最优解
% pbf is a m*1 matrix 个体最优适应度
% gbf is a number 全局最优适应度
n=1;
m=2;%粒子个数
c1=0.5;
c2=0.5;
Nmax=50;%最大迭代次数

b=200;c=7;
wmax=0.95;
wmin=0.15;
%X=[Spca Skpca q sigma];
xmax=[1000];
xmin=[0.1];

for j=1:n
    x(:,j)=xmin(j)+(xmax(j)-xmin(j))*rand(m,1);
end
x(1,:)=[1];%初始输入

vmax=0.8*(xmax-xmin);
v=[1*rand(m,n)];
step=1
cpt=cputime;
for i=1:m
    f(i)=obf_PSO(x(i,:));
end
step=2
cputime-cpt
%找出个体最优和全局最优
pbx=x;
pbf=f;
[gbf i]=min(pbf);%%%%%%%%%%%%%%%%%%%%%注意
gbx=pbx(i,:);
w=1;

for i=1:m
    v(i,:)=w*v(i,:)+c1*rand*(pbx(i,:)-x(i,:))+c2*rand*(gbx-x(i,:));
    for j=1:n
        if v(i,j)>vmax(j)
            v(i,j)=vmax(j);
        elseif v(i,j)<-vmax(j)
            v(i,j)=-vmax(j);
        end
    end
    x(i,:)=x(i,:)+v(i,:);
    for j=1:n
        if x(i,j)<xmin(j)
            x(i,j)=xmin(j);
        end
        if x(i,j)>xmax(j)
            x(i,j)=xmax(j);
        end                
    end
end

%开始迭代
for k=1:Nmax
    disp('fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_fuck_')
    k
    for i=1:m
        f(i)=obf_PSO(x(i,:));
    end
    for i=1:m
        if f(i)<pbf(i)
            pbf(i)=f(i);
            pbx(i,:)=x(i,:);
        end
    end
    [gbf i]=min(pbf);
    gbx=pbx(i,:);
    pso_out(k)=-gbf;
    pso_in(k)=gbx;
%     GBF(k)=gbf;
%     RMSE(k)=1/sqrt(gbf);
    w=wmax-(wmax-wmin)/Nmax*k;
    %w=wmax-(wmax-wmin)/atan(b)*atan(b*((k/Nmax)^c));
    for i=1:m
        v(i,:)=w*v(i,:)+c1*rand*(pbx(i,:)-x(i,:))+c2*rand*(gbx-x(i,:));
        for j=1:n
            if v(i,j)>vmax(j)
                v(i,j)=vmax(j);
            elseif v(i,j)<-vmax(j)
                v(i,j)=-vmax(j);
            end
        end
            x(i,:)=x(i,:)+v(i,:);  
            for j=1:n
                if x(i,j)<xmin(j)
                    x(i,j)=xmin(j);
                end
                if x(i,j)>xmax(j)
                    x(i,j)=xmax(j);
                end                
            end
    end
end
%pso_out(1)=0.45916;
plot(1:Nmax,pso_out,'r-');hold off;
