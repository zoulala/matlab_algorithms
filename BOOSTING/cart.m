%输入排序后的自变量X，对应的因变量Y，输出划分的情况Z，即对应的残差平方 
%找到最优的划分点
function [cut_point,err_e] = cart(X ,Y)
    %err_e=[];%每个变量的残差平方
    %cut_point=[];%1*3 存储每次的切分点和对应的左右子树值
    z1=mean([X(1);X(2)]);%划分点
    y1=Y(1);%划分点对应的左子树的值
    y2=mean(Y(2:end));%划分点对应的右子树的值
    
    %计算该种划分情况下对应的残差平方
    err=zeros(size(Y));
    err(1)=0;
    
    for j=2:size(Y,1)
      err(j)=(Y(j)-y2);
    end
    err_sum=sum(err.^2);
    err_e=err;
    cut_point=[z1,y1,y2];
for i=2:(size(X,1)-1)
    z1=mean([X(i);X(i+1)]);%划分点
    y1=mean(Y(1:i));%划分点对应的左子树的值
    y2=mean(Y(i+1:end));%划分点对应的右子树的值
    
    %计算该种划分情况下对应的残差平方
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

