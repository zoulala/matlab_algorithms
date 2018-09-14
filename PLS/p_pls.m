function p_pls( x,y,r )
%该函数实现多项式-pls算法功能,在原pls基础上进行改进，对提取的成分矩阵进行多项式扩展，实现一种非线性变换。用于处理非线性数据。
% 作者：zlw
% 时间：2015-10-14
%说明：x,y分别为辅助变量数据和主导变量数据输入，r选定成分个数

X=zscore(x);

% 
% % 数据归一化
% [n,~]=size(x);
% x_2=sqrt(diag(x*x'));
% for i=1:n
%     X(i,:)=x(i,:)/x_2(i);
% end
% X=zscore(X);

Y=zscore(y);
[n,mx]=size(X);

E0=X;F0=Y;
for i=1:mx
    M=E0'*F0*F0'*E0;
    [L, K]=eig(M); %计算特征值K、特征向量T
    S=diag(K);%提取特征值
    [~,ind]=sort(S,'descend');%按大-小排序，ind序号
    w(:,i)=L(:,ind(1)); %提出最大特征值对应的特征向量
    t(:,i)=E0*w(:,i);     %计算成分 ti 的得分
    alpha(:,i)=E0'*t(:,i)/(t(:,i)'*t(:,i)) ;%计算                 alpha_i ,其中(t(:,i)'*t(:,i))等价于norm(t(:,i))^2
    E1=E0-t(:,i)*alpha(:,i)' ;   %计算残差矩阵
    E0=E1;
        
end

T=t(:,1:r);
% b=Y'*T/(T'*T);%标准化数据回归系数
% YY=T*b';%标准化拟合值
% yy=YY*std(y)+mean(y);%反标准化


%********* 对主元进行多项式扩展 **********
a=r;
TT(:,1:a)=T;
TT(:,a+1:2*a)=T.^2;
k=2*a+1;
for i=1:a-1
    for j=i+1:a
        TT(:,k)=diag(T(:,i)*T(:,j)');
        k=k+1;
    end
end
%****************************************

PZ=[TT,Y];
IN=zbhg(PZ);
TTN=TT(:,IN);
bTN=Y'*TTN/(TTN'*TTN);%对逐步多项式主元的回归系数
YTN=TTN*bTN';
yTN=YTN*std(y)+mean(y);%反标准化
figure;
plot(y);title('逐步多项式偏最小二乘回归');
hold on;
plot(yTN);legend('real value','prediction of SWP-PLS');
hold off;

%*************** 计算误差 ****************
e=y-yTN;
disp('均方根误差：')
disp(sqrt(e'*e/n));
disp('误差平均值：')
disp(sum(abs(e))/n);
disp('误差最大值');
disp(max(abs(e)));
disp('相对误差');
disp(abs(e./y*100));
disp('相对误差最大值');
disp(max(abs(e./y*100)));
disp('相对误差平均值');
disp(mean(abs(e./y*100)));
figure;
hist(abs(e./y*100));title('SWP-PLS-相对误差直方图'); axis([0 45 0 25]);
disp('************************* 以下p-pls*****************************************');



b=Y'*TT/(TT'*TT);%对多项式主元的回归系数

YY=TT*b';%标准化拟合值
yy=YY*std(y)+mean(y);%反标准化
%******************** 画图 ************************
figure;
plot(y);title('多项式偏最小二乘回归');
hold on;
plot(yy);legend('real value','prediction of P-PLS');
hold off;

%*************** 计算误差 ****************
e=y-yy;
disp('均方根误差：')
disp(sqrt(e'*e/n));
disp('误差平均值：')
disp(sum(abs(e))/n);
disp('误差最大值');
disp(max(abs(e)));
disp('相对误差');
disp(abs(e./y*100));
disp('相对误差最大值');
disp(max(abs(e./y*100)));
disp('相对误差平均值');
disp(mean(abs(e./y*100)));

figure;
hist(abs(e./y*100));title('P-PLS-相对误差直方图'); 
axis([0 45 0 25]);
end



