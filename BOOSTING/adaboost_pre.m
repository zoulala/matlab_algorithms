%%---------- 《提升回归树算法》：预测专用 -------------
%说明： 
%       输入：测试数据X=[n*m],生成树CUT=[p*5],CUT(:,1)为切分点，CUT(:,2:3)为切分值，CUT(:,4)为权重系数，CUT(:,5)为变量标志位；
%       输出：预测Y=[n*1];
%      

%作者：zlw 

%时间：2016-07-27
%%
function [ Y  ] = adaboost_pre( x, CUT )
%ADABOOST_PRE Summary of this function goes here
%   Detailed explanation goes here
[n,~]=size(x);

Y=[];
for i=1:n
    y_predict=0;
    
    for j=1:size(CUT,1)
        n_r=CUT(j,end);
        if x(i,n_r)<CUT(j,1)
            y_predict=y_predict+CUT(j,4)*CUT(j,2);
        else
            y_predict=y_predict+CUT(j,4)*CUT(j,3);
        end
        
    end
    

    Y = [Y;y_predict];
end


end

