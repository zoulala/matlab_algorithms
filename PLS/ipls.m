%%%%%%%%%%%%%%% 该程序用于回归建模的变量筛选（间隔pls） %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% 包括前向交叉验证和后向筛交叉验证选法 %%%%%%%%%%%%%%%%

clc;clear;close all;
%x全波长变量,y化验值

load FREEZEGATEST.mat
Xtrn=f_sd_ll_a;
Ytrn=f_y_ll_a;
x=Xtrn(:,1:400);
y=Ytrn;
[n,m]=size(x);
k=m/5;%有k组区间，每个区间5个变量；



%**************** 前向选取区间 forward_ipls *************************
xx=x;t=1:k;XX=[];%XX逐一存放最优区间变量%xx存放残差区间变量
for j=1:k 
    r_pls=3+floor(2*sqrt(j));%成分个数随变量增多而增加
    for i=1:k-j+1;
        X=[XX,xx(:,(5*i-4):5*i)];%前向增加变量
        [p,X_mean,X_std,Y_mean,Y_std,b]= pls_mod( X,y,r_pls );%建立pls模型
        y_pls = pls_pr( X,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%pls预测输出
        e=y-y_pls;
        RMSE(i)=sqrt(e'*e/n);
    end
    e_min(j)=min(RMSE);
    k_min=find(RMSE()==min(RMSE));%误差最小的区间序号
    RMSE=[];
    s(j)=t(k_min);
    XX=[XX,x(:,5*s(j)-4:5*s(j))]; %XX逐一存放最优区间变量
    xx(:,5*k_min-4:5*k_min)=[];%xx存放残差区间变量
    t(k_min)=[];%t存放残余区间序号，为逐一删除最优区间后剩下的区间序号   
    if j>1
        if e_min(j)>e_min(j-1)
%             disp(j-1);
            disp('前向误差最小：')
            disp(e_min(j-1))
            break;
        end
    end
end
disp('前向选取的变量区间：');
disp(s(1:end-1));

%**************** 反向选取区间 reverse_ipls *************************
xx=x;t=1:k;%
e_min=[];s=[];
for j=1:k 
%     r_pls=3+floor(2*sqrt(k/j));%成分个数随变量增多而增加
    r_pls=3+floor(2*sqrt(k-j+1));%成分个数随变量增多而增加
    for i=1:k-j+1;
        X=xx;
        X(:,(5*i-4):5*i)=[];%后向删除区间变量
        [p,X_mean,X_std,Y_mean,Y_std,b]= pls_mod( X,y,r_pls );%建立pls模型
        y_pls = pls_pr( X,p,X_mean,X_std,Y_mean,Y_std,b,r_pls);%pls预测输出
        e=y-y_pls;
        RMSE(i)=sqrt(e'*e/n);
    end
    e_min(j)=min(RMSE);
    k_min=find(RMSE()==min(RMSE));%误差最小的区间序号
    RMSE=[];
    s(j)=t(k_min);
    xx(:,5*k_min-4:5*k_min)=[];%xx去除最差区间变量         
    if j>1
        if e_min(j)>e_min(j-1)
%             disp(j-1);
            disp('反向误差最小：')
            disp(e_min(j-1))
            break;
        end
    end
    t(k_min)=[];%t存放剩余最优区间序号，逐一删除最差区间后剩下的区间序号 
end
disp('反向选取的变量区间：');
disp(t);
