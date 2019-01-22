%%---------- 《提升回归树算法》：建模专用 -------------用于回归
%说明： 
%       输入X=[n*m],Y=[n*1];输出CUT=[p*4],CUT(:,1)为切分点，CUT(:,2:3)为切分值，CUT(:,4)为变量标志位；
%       ERR为训练误差精度，ECHO为训练最大步数；
%       使用CART函数进行切分。

%作者：zlw 

%时间：2016-07-14

%---------------------------------------------------
%%
function [CUT]=boostree_model(X,Y,ERR,ECHO)
%ERR=0.1;ECHO=100;
X_train = X;
Y_train = Y;

m=size(X_train, 2); %变量维数
n=size(X_train, 1); %样本数

%将X_train和Y_train按照X_train从小到大排列
B=[X_train,Y_train];%组合成一个矩阵 
AB=zeros(n,m+1,m);
CUT=[]; sum_e=zeros(m,1);err_e=zeros(n,m);sum_min=10;echo=0;
while(sum_min>ERR && echo<ECHO)

    for i=1:m
        AB(:,:,i)=sortrows(B,i);%将矩阵按照第i列升序跟着排列
    end

    %几个波长意味着比较几次分割点
    for i=1:m
        [cut,err] = cart(AB(:,i,i) ,AB(:,end,i));
        sum_e(i)=sum(err.^2);
        err_e(:,i)=err;
        cut_point(i,:)=cut;
    end
    sum_min=min(sum_e);
    min_r=find(sum_e==sum_min);min_r=min_r(1);%避免存在多个最小值
    CUT=[CUT; cut_point(min_r,:), min_r];
    err_min=err_e(:,min_r);
    B=[AB(:,1:end-1,min_r),err_min];%用误差列替换原y列，重新生成B矩阵
    echo=echo+1;
end
end
