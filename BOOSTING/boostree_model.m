%%---------- �������ع����㷨������ģר�� -------------���ڻع�
%˵���� 
%       ����X=[n*m],Y=[n*1];���CUT=[p*4],CUT(:,1)Ϊ�зֵ㣬CUT(:,2:3)Ϊ�з�ֵ��CUT(:,4)Ϊ������־λ��
%       ERRΪѵ�����ȣ�ECHOΪѵ���������
%       ʹ��CART���������з֡�

%���ߣ�zlw 

%ʱ�䣺2016-07-14

%---------------------------------------------------
%%
function [CUT]=boostree_model(X,Y,ERR,ECHO)
%ERR=0.1;ECHO=100;
X_train = X;
Y_train = Y;

m=size(X_train, 2); %����ά��
n=size(X_train, 1); %������

%��X_train��Y_train����X_train��С��������
B=[X_train,Y_train];%��ϳ�һ������ 
AB=zeros(n,m+1,m);
CUT=[]; sum_e=zeros(m,1);err_e=zeros(n,m);sum_min=10;echo=0;
while(sum_min>ERR && echo<ECHO)

    for i=1:m
        AB(:,:,i)=sortrows(B,i);%�������յ�i�������������
    end

    %����������ζ�űȽϼ��ηָ��
    for i=1:m
        [cut,err] = cart(AB(:,i,i) ,AB(:,end,i));
        sum_e(i)=sum(err.^2);
        err_e(:,i)=err;
        cut_point(i,:)=cut;
    end
    sum_min=min(sum_e);
    min_r=find(sum_e==sum_min);min_r=min_r(1);%������ڶ����Сֵ
    CUT=[CUT; cut_point(min_r,:), min_r];
    err_min=err_e(:,min_r);
    B=[AB(:,1:end-1,min_r),err_min];%��������滻ԭy�У���������B����
    echo=echo+1;
end
end
