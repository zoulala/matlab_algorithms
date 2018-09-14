clear all
close all
clc
load BP50GATEST.mat    %柴油沸点数据
% 训练样本集
Xtrn=bp50_s1d_ll_a;
Ytrn=bp50_y1_ll_a;

% 测试样本集
Xtst=bp50_s1d_ll_b;
Ytst=bp50_y1_ll_b;

mX=mean(Xtrn);
stdX=std(Xtrn);

mY=mean(Ytrn);
stdY=std(Ytrn);

Ntrn=length(Ytrn);
Ntst=length(Ytst);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 标准化
Xtrn=zscore(Xtrn);
Ytrn=zscore(Ytrn);

Xtst=(Xtst-repmat(mX,Ntst,1))./repmat(stdX,Ntst,1);
Ytst=(Ytst-repmat(mY,Ntst,1))./repmat(stdY,Ntst,1);


LV=15;% PLS 主成分个数

[B b]=plskernel_1(Xtrn,Ytrn,LV);

Ypre_tst=Xtst*B+b;%对测试数据的预测结果

% 反标准化
Yreal=Ytst*stdY+mY;
Yreal_pre=Ypre_tst*stdY+mY;

RMSE_tst=sqrt(sum((Yreal-Yreal_pre).^2)/Ntst)

figure;hold on
plot(Yreal,'r-')
plot(Yreal_pre,'b--')
legend('化验值','预测值')







