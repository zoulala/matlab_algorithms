%%自适应提升算法(adaboosting)实现多维特征进行 二分类（-1,1）问题；

clc;clear;close all;

x=[2 4 0 3 1 5 6 7 8 9;2 6 7 22 5 15 4 9 8 1;5 8 12 9 0 11 30 7 6 4;5 4 9 0 0.2 2 7 6 3 1]';
y=[1 -1 1 -1 1 -1 1 1 1 -1]';
xy=[x,y];

%--------------------------------------------
[n,m]=size(x);
class_y=unique(y);

%xy=sortrows(xy,1);%按某列排序；
for i=1:m
    [XY(:,:,i),DI(:,i)]=sortrows(xy,i);%将矩阵按照第i列升序跟着排列
end

D=1/n*ones(n,m);%样本初始权值；

%-------   -------
x=xy(:,1);
y=xy(:,end);
echo=1;p_err=1;Fx=0;
while (p_err>0.01 && echo<100)

    G0=zeros(n,1);D0=zeros(n,1);
    for i=1:m
        [cut(i),cut_v(i,:),err(i),G(:,i)] = C_cart(XY(:,i,i) ,XY(:,end,i),D(:,i));%计算各个变量分类的最优切分点、误差、对应的预测值  
    end

    min_err=min(err); %最小分类误差，（需要注意err可能为0）
    min_i=find(err==min_err);min_i=min_i(1);%分类误差最小的变量序号
    op_cut=cut(min_i);  %最优分类阈值
    op_G=G(:,min_i); %分类值
    alpha=0.5*log((1-min_err)/min_err); %G的系数

    G0(DI(:,min_i))=op_G;%原始序号下的预测值
    
    Fx=alpha*G0+Fx;%决策函数
    %计算分类错误率
    a=Fx>0;
    b=y>0;
    p_err=sum(abs(a-b))/n;


    %---------- 更新权值 ----------  
    sumD=0;
    for i=1:n
       D(i,min_i)=D(i,min_i)*exp(-alpha*XY(i,end,min_i)*op_G(i)); 
       sumD=sumD+D(i,min_i);
    end
    D(:,min_i)=D(:,min_i)/sumD;

    D0(DI(:,min_i))=D(:,min_i);%原始序号下的样本权值
    for k=1:m
       D(:,k)=D0(DI(:,k)) ;%各列为列排序后的样本权值
    end


    echo=echo+1;
    
    disp(echo);
    disp(p_err);
end



