%%%%%%%%%%%%%%% 该程序用于回归建模的变量筛选（vippls） %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  %%%%%%%%%%%%%%%%

clc;clear;close all;
%x全波长变量,y化验值

load FREEZEGATEST.mat
Xtrn=f_sd_ll_a;
Ytrn=f_y_ll_a;
x=Xtrn(:,1:100);
y=Ytrn;
[n,m]=size(x);

r=m;
X=zscore(x);
Y=zscore(y);
[~,mx]=size(X);

E0=X;F0=Y;
for i=1:r
    M=E0'*F0*F0'*E0;
    [L, K]=eig(M); %计算特征值K、特征向量T
    S=diag(K);%提取特征值
    [~,ind]=sort(S,'descend');%按大-小排序，ind序号
    w(:,i)=L(:,ind(1)); %提出最大特征值对应的特征向量
    t(:,i)=E0*w(:,i);     %计算成分 ti 的得分
    ap(:,i)=E0'*t(:,i)/(t(:,i)'*t(:,i)) ;%计算特征矩阵ap
    E1=E0-t(:,i)*ap(:,i)' ;   %计算残差矩阵
    E0=E1;
        
end

%计算每个变量的vip值，vip值越大代表该变量越重要，从大到小依次选取前几个变量。
for i=1:mx
    temp4=0;temp5=0;
    for j=1:r
        temp1=ap(:,j)'*ap(:,j)*t(:,j)'*t(:,j);
        temp2=abs(w(i,j))/(w(:,j)'*w(:,j));
        temp3=temp1*temp2;
        temp4=temp4+temp3;
        temp5=temp5+temp1;    
    end
    vip(i)=sqrt(mx*temp4/temp5);
end
disp(vip);
[~,sn]=sort(vip,'descend');%sn即为从高到低排列变量序号
disp('变量重要性依次排序')
disp(sn)
