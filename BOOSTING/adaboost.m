%%����Ӧ�����㷨(adaboosting)ʵ�� �����ࣨ-1,1�����⣻

clc;clear;close all;

x=[2 4 0 3 1 5 6 7 8 9]';
y=[1 -1 1 -1 1 -1 1 1 1 -1]';
xy=[x,y];

%--------------------------------------------
[n,m]=size(x);
class_y=unique(y);

xy=sortrows(xy,1);%��ĳ������

D=1/n*ones(n,1);%������ʼȨֵ��

%-------   -------
x=xy(:,1);
y=xy(:,end);
echo=1;p_err=1;Fx=0;
while (p_err>0.01 && echo<100)

    pre0=ones(n,1);
    for i=1:n-1

       cut(i)= (x(i)+x(i+1))/2;%������ֵ

    %----- %�õ��������   
       pre(1:i)=class_y(1)*pre0(1:i);%��Ϊ��1
       pre(i+1:n)=class_y(2)*pre0(i+1:n);%��Ϊ��2
       G1=[pre(1:i),pre(i+1:n)]';
       err1=0;
       for j=1:n
          if y(j)~=pre(j)
              err1=err1+D(j);
          end
       end

       pre(1:i)=class_y(2)*pre0(1:i);%��Ϊ��2
       pre(i+1:n)=class_y(1)*pre0(i+1:n);%��Ϊ��1
       G2=[pre(1:i),pre(i+1:n)]';
       err2=0;
       for j=1:n
          if y(j)~=pre(j)
              err2=err2+D(j);
          end
       end

       if err1<=err2
           err(i)=err1;G(:,i)=G1;
       else
           err(i)=err2;G(:,i)=G2;
       end
    %--------------------------

    end

    min_err=min(err); %��С�������
    min_i=find(err==min_err);min_i=min_i(1);
    op_cut=cut(min_i);  %���ŷ�����ֵ
    op_G=G(:,min_i); %����ֵ
    alpha=0.5*log((1-min_err)/min_err); %G��ϵ��

    Fx=alpha*op_G+Fx;%���ߺ���
    %������������
    a=Fx>0;
    b=y>0;
    p_err=sum(abs(a-b))/n;


    %---------- ����Ȩֵ ----------  
    sumD=0;
    for i=1:n
       D(i)=D(i)*exp(-alpha*y(i)*op_G(i)); 
       sumD=sumD+D(i);
    end
    D=D/sumD;

    echo=echo+1;

end


