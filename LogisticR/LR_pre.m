function [ y ] = LR_pre( x,w,x_mean,x_std )
%逻辑回归
%参考：http://blog.csdn.net/hechenghai/article/details/46817031
 
[n,~]=size(x);
%标准化
for j=1:n
    x(j,:)=(x(j,:)-x_mean)./x_std;
end
x = [ones(n, 1), x]; %x增加一维。因为前面文字或前几节说了

g = inline('1.0 ./ (1.0 + exp(-z))','z'); %这个就相当于制造了一个function g（z）=1.0 ./ (1.0 + exp(-z))

y = g(x*w);  %预测
end


