%%---------- �������ع����㷨����Ԥ��ר�� -------------
%˵���� 
%       ���룺��������X=[n*m],������CUT=[p*4],CUT(:,1)Ϊ�зֵ㣬CUT(:,2:3)Ϊ�з�ֵ��CUT(:,4)Ϊ������־λ��
%       �����Ԥ��Y=[n*1];
%      

%���ߣ�zlw 

%ʱ�䣺2016-07-14

%---------------------------------------------------

function [ Y ] = boostree_pre( X, CUT )

%����Ԥ��
X_test = X;
Y=[];
m=size(X_test, 2); %����ά��
n=size(X_test, 1); %����������

for i=1:n
    y_predict=0; 
    x_predict=X_test(i,:);
    for j=1:size(CUT,1)
    %�����зֵ��Ӧ�Ĳ�����������
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

