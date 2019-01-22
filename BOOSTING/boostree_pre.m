%%---------- 《提升回归树算法》：预测专用 -------------
%说明： 
%       输入：测试数据X=[n*m],生成树CUT=[p*4],CUT(:,1)为切分点，CUT(:,2:3)为切分值，CUT(:,4)为变量标志位；
%       输出：预测Y=[n*1];
%      

%作者：zlw 

%时间：2016-07-14

%---------------------------------------------------

function [ Y ] = boostree_pre( X, CUT )

%依次预测
X_test = X;
Y=[];
m=size(X_test, 2); %变量维数
n=size(X_test, 1); %测试样本数

for i=1:n
    y_predict=0; 
    x_predict=X_test(i,:);
    for j=1:size(CUT,1)
    %根据切分点对应的波长分类讨论
        n_r=CUT(j,end);
        if x_predict(1,n_r)<CUT(j,1)
            y_predict=y_predict+CUT(j,2);
        else
            y_predict=y_predict+CUT(j,3);
        end
    end 
    Y = [Y;y_predict];
end

end

