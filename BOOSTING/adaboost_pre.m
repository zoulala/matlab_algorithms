%%---------- �������ع����㷨����Ԥ��ר�� -------------
%˵���� 
%       ���룺��������X=[n*m],������CUT=[p*5],CUT(:,1)Ϊ�зֵ㣬CUT(:,2:3)Ϊ�з�ֵ��CUT(:,4)ΪȨ��ϵ����CUT(:,5)Ϊ������־λ��
%       �����Ԥ��Y=[n*1];
%      

%���ߣ�zlw 

%ʱ�䣺2016-07-27
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

