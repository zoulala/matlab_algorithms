%************** 连续投影算法选取辅助变量,用于pls建模（SPA PLS） ***************
%(successive projections algorithm) SPA
%参考文献：《基于连续投影算法的土壤总氮近红外特征波长的选取》
%时间：2015-11-5

clc;clear;close all;
%x全波长变量,y化验值

load FREEZEGATEST.mat
Xtrn=f_sd_ll_a;
Ytrn=f_y_ll_a;

%************************** 初始化 和 参数设置*********************************
x=Xtrn(:,1:400);%这里选取了前100维向量。
y=Ytrn;

[n,m]=size(x);
N=10;%迭代中需要选取的变量数，N<=m
r_pls=5;%pls成分个数，r_pls<=N

%**********************  连续投影算法 *********************************
for i=1:m
    xi=x(:,i);
    t=1:m;t(i)=[];
    KN(1)=i;%第i个变量必选
    for k=2:N
        px=zeros(n,m);pl=zeros(1,m);
        for j=t
            xj=x(:,j);
            px(:,j)=xi-(xi'*xj)*xj/(xj'*xj);%xi在xj上的正交投影px（即xi减去在xj上的投影）
            pl(j)=px(:,j)'*px(:,j);
        end
        [~,ind]=sort(pl,'descend');
        xi=px(:,ind(1));
        ti=find(t()==ind(1));
        t(ti)=[];
        KN(k)=ind(1);
    end
    MN(i,:)=KN;
end
MN  %每一行代表一组变量的序号，共选择了m组变量

%********* 对m组变量分别进行pls建模，选取误差rmse最小的一组作为最终辅助变量 **********
for i=1:m
    X=x(:,MN(i,:));
    [p,X_mean,X_std,Y_mean,Y_std,b]= pls_mod( X,y,r_pls );%建立pls模型
    y_pls = pls_pr( X,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%pls预测输出
    e=y-y_pls;
    rmse(i)=sqrt(e'*e/n);
end
e_min=min(rmse);
a=find(rmse()==e_min);
disp('连续投影-最优变量组：');
disp(MN(a,:));
%*************** 按贡献值通过F检验进一步筛选变量 **************************
AN=MN(a,:);
Qtol=(rmse(a))^2*n;%残差平方和；
alpha=0.95;
disp('********************* 以下是按贡献值F检验筛选变量过程 *********************');
for i=1:N
    Q=[];
    for j=1:N-i+1
        AP=AN;
        AP(j)=[];
        X=x(:,AP);
        [p,X_mean,X_std,Y_mean,Y_std,b]= pls_mod( X,y,r_pls );%建立pls模型
        y_pls = pls_pr( X,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%pls预测输出
        e=y-y_pls;
        Q(j)=e'*e;
    end
    pm=find(Q()==min(Q));
    c(i)=(min(Q)-Qtol)/Qtol;%
    
    %*************** F检验 ******************
    if i==1
        F=(c(1)/(n-2)) / (Qtol/(n-1));
        disp('F检验值:');
        disp(F);
    else
        F=(c(i)/(n-i-1)) / (c(i-1)/(n-i));
        disp('F检验值:');
        disp(F);
    end
    FV= finv(alpha,n-i-1,n-i);
    if F > FV
        disp('不可以继续删除变量');
        break;
        else
        disp(['可以删除变量',num2str(AN(pm))]);
    end
               
    AN(pm)=[];%去除贡献最小的变量；
    Qtol=min(Q);
end
disp('最终选取的变量：');
disp(AN);



 