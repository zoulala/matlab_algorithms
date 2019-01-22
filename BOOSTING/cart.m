%�����������Ա���X����Ӧ�������Y��������ֵ����Z������Ӧ�Ĳв�ƽ�� 
%�ҵ����ŵĻ��ֵ�
function [cut_point,err_e] = cart(X ,Y)
    %err_e=[];%ÿ�������Ĳв�ƽ��
    %cut_point=[];%1*3 �洢ÿ�ε��зֵ�Ͷ�Ӧ����������ֵ
    z1=mean([X(1);X(2)]);%���ֵ�
    y1=Y(1);%���ֵ��Ӧ����������ֵ
    y2=mean(Y(2:end));%���ֵ��Ӧ����������ֵ
    
    %������ֻ�������¶�Ӧ�Ĳв�ƽ��
    err=zeros(size(Y));
    err(1)=0;
    
    for j=2:size(Y,1)
      err(j)=(Y(j)-y2);
    end
    err_sum=sum(err.^2);
    err_e=err;
    cut_point=[z1,y1,y2];
for i=2:(size(X,1)-1)
    z1=mean([X(i);X(i+1)]);%���ֵ�
    y1=mean(Y(1:i));%���ֵ��Ӧ����������ֵ
    y2=mean(Y(i+1:end));%���ֵ��Ӧ����������ֵ
    
    %������ֻ�������¶�Ӧ�Ĳв�ƽ��
    err=zeros(size(Y));
    for j=1:i
      err(j)=(Y(j)-y1);
    end
    for j=i+1:size(Y,1)
      err(j)=(Y(j)-y2);
    end
    s=sum(err.^2);
    if s<err_sum
         err_sum=s;
         err_e=err;
         cut_point=[z1,y1,y2];
    else
        continue
    end
end

end

