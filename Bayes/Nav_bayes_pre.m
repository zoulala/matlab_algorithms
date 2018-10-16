function [pyxn ] = Nav_bayes_pre( xx ,unx,uny, pxy, py,  C)
%--------------------------------求后验概率---------------------------
%输出：pyxn:按uny类别排序 得到对应的后验概率，pyxn(:,end)为所属类别项
[n,~]=size(xx);
m=length(C)-1;
pyxn=[];
for k=1:n
    xxx=xx(k,:);
    sum=0;
    for i=1:C(m+1)
        mul=1;
        for j=1:m
            j_n= unx{j}==xxx(j);
            mul=mul*pxy(j_n,j,i);
        end
        pxx(i)=mul;    
        sum=sum+py(i)*pxx(i);            
    end
    p_b=sum;%分母，全概率

    for i=1:C(m+1)
        mul=1;
        for j=1:m
            j_n= unx{j}==xxx(j);
            mul=mul*pxy(j_n,j,i);
        end
        pxx(i)=mul;
        p_a=py(i)*pxx(i);%分子，联合概率


        pyx(i)=p_a/p_b;
    end

    y_pre=max(pyx);%预测的最大概率
    rx=find(pyx==y_pre);
    y_num=uny(rx(1));%预测最大概率的所属类别
    
    pyxn=[ pyxn;[pyx,y_num]];
end

end

