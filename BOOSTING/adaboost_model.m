%%---------- �������㷨-��ά������ģר�� -------------���ڶ�����
%˵����      
%       ����X=[n*m],Y=[n*1]��-1/1����ֵ��;
%       ���CUT=[p*4],CUT(:,1)Ϊ�зֵ㣬CUT(:,2:3)Ϊ�з�ֵ��CUT(:,4)ΪȨ��ϵ����CUT(:,5)Ϊ������־λ��
%       ERRΪѵ�����ȣ�ECHOΪѵ���������
%       ʹ��C_CART���������з֡�
%���磺
%       x=[2 4 0 3 1 5 6 7 8 9;2 6 7 22 5 15 4 9 8 1;5 8 12 9 0 11 30 7 6 4;5 4 9 0 0.2 2 7 6 3 1]';
%       y=[1 -1 1 -1 1 -1 1 1 1 -1]';

%���ߣ�zlw 

%ʱ�䣺2016-07-27

%---------------------------------------------------
%%

function [ CUT ] = adaboost_model( x,y,ERR,ECHO)
%ADABOOST_MODEL Summary of this function goes here
%   Detailed explanation goes here
%%����Ӧ�����㷨(adaboosting)ʵ�ֶ�ά�������� �����ࣨ-1,1�����⣻

xy=[x,y];

%--------------------------------------------
[n,m]=size(x);

%xy=sortrows(xy,1);%��ĳ������
for i=1:m
    [XY(:,:,i),DI(:,i)]=sortrows(xy,i);%�������յ�i�������������
end

D=1/n*ones(n,m);%������ʼȨֵ��

%-------   -------
y=xy(:,end);
echo=1;p_err=1;Fx=0;CUT=[];
while (p_err>ERR && echo<ECHO)

    G0=zeros(n,1);D0=zeros(n,1);
    for i=1:m
        [cut(i),cut_v(i,:),err(i),G(:,i)] = C_cart(XY(:,i,i) ,XY(:,end,i),D(:,i));%���������������������зֵ㡢����Ӧ��Ԥ��ֵ  
    end

    min_err=min(err); %��С����������Ҫע��err����Ϊ0��
    min_i=find(err==min_err);min_i=min_i(1);%���������С�ı������
    op_cut=cut(min_i);  %���ŷ�����ֵ
    op_G=G(:,min_i); %����ֵ
    op_cutv=cut_v(min_i,:);%����ֵ
    alpha=0.5*log((1-min_err)/min_err); %G��ϵ��

    CUT=[CUT;op_cut,op_cutv,alpha,min_i];
    
    G0(DI(:,min_i))=op_G;%ԭʼ����µ�Ԥ��ֵ
    
    Fx=alpha*G0+Fx;%���ߺ���
    %������������
    a=Fx>0;
    b=y>0;
    p_err=sum(abs(a-b))/n;


    %---------- ����Ȩֵ ----------  
    sumD=0;
    for i=1:n
       D(i,min_i)=D(i,min_i)*exp(-alpha*XY(i,end,min_i)*op_G(i)); 
       sumD=sumD+D(i,min_i);
    end
    D(:,min_i)=D(:,min_i)/sumD;

    D0(DI(:,min_i))=D(:,min_i);%ԭʼ����µ�����Ȩֵ
    for k=1:m
       D(:,k)=D0(DI(:,k)) ;%����Ϊ������������Ȩֵ
    end


    echo=echo+1;
    
end





end
