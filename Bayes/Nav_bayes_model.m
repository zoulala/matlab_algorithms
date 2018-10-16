function [ unx, uny, pxy, py,  C ] = Nav_bayes_model( x,y )
%朴素贝叶斯 --- 分类算法
%假设x特征之间相互独立

%输入： x[n*m]=[特征1，特征2，...特征m]，其中特征1、2...m的值又分别为ij类(即离散数值)
%       y[n*1]=[类1；类2；...类k]
%如：x=[1,'高'      y=[‘是’
%       0,'低'         ‘否’
%       1,'中'         ‘是’
%       0,'高']        ‘否’]（注：目前只能为数值矩阵形式）

%输出：unx:x类矩阵 uny：y类向量  pxy：条件概率  py：先验概率  C：各特征的类的个数


[n,m]=size(x);%确定x特征维数m，
for i=1:m 
    C(i)=length(unique(x(:,i)));%确定x每个特征的类数Ci；
end
uny=unique(y);
C(m+1)=length(uny);%确定y的类数；

%-----------------------------计算先验概率，条件概率------------------
for i=1:C(m+1)  %y的类别数
    num= y==uny(i);
    sumy(i)=sum(y==uny(i));
    py(i)=sumy(i)/n;%先验概率P（Y=yi）
    
    xi=x(num,:);%y==yi下的x矩阵；
    for j=1:m   %x特征变量个数
        unx{j}=unique(x(:,j));
        for k=1:C(j)  %x每个特征下的类别数
            pxy(k,j,i)=sum(xi(:,j)==unx{j}(k))/sumy(i);%条件概率矩阵，每一列为yi条件下xi特征的各类别的条件概率
        end
    end
end


end

