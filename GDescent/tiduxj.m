%%
%梯度下降算法(gradient descent)
%说明：对一个二元多项式进行求最小值(x1,x2)——>min(fn)
%时间：2016-01-04
%作者：zlw

%%
clc;clear;close all;

syms x1 x2 r;
fn=x1-x2+2*x1^2+2*x1*x2+x2^2;%定义函数
%exmp:fn0=subs(fn,{x1,x2},{1,2});%计算(1,2)处的函数值
dfn1=diff(fn,x1);%求x1偏导
dfn2=diff(fn,x2);%求x2偏导

e=0.000001;%误差范围
x_next=[0,0];%初始给定点
for k=1:10000
    t1(k)=x_next(1);t2(k)=x_next(2);
    dfn=[subs(dfn1,{x1,x2},{t1(k),t2(k)}),subs(dfn2,{x1,x2},{t1(k),t2(k)})];%计算该点的偏导
    d=-dfn;
    if d*d'<=e
        x_min=[t1(k),t2(k)];%输出最优点
        break;
    else
        x_temp=[t1(k),t2(k)]+r*d;
        yr=subs(fn,{x1,x2},{x_temp(1),x_temp(2)});
        dyr=diff(yr,r);
        r_min=double(solve(dyr,r));  %(求最优步长r)导数为0时的r值,solve求等式方程很强大
        x_next=[t1(k),t2(k)]+r_min*d;
    end
end
disp('最小值点(x1,x2)为：');
disp(x_min);
disp('最小值为：')
disp(double(subs(fn,{x1,x2},x_min)));

