
function y=pls0(pz,Xnum,Ynum)
%************  pls0（） **************
%说明：输入数据pz=[X,Y],Xnum为辅助变量维数，Ynum为主导变量维数
%采用交叉有效性选取成分个数，不是很理想，可以自行修改r

[row,col]=size(pz);
aver=mean(pz);
stdcov=std(pz); %求均值和标准差
rr=corrcoef(pz);   %求相关系数矩阵
data=zscore(pz); %数据标准化
stdarr = ( pz - aver(ones(row,1),:) )./ stdcov( ones(row,1),:);  % 标准化自变量
n=Xnum;m=Ynum;   %n 是自变量的个数,m是因变量的个数
x0=pz(:,1:n);y0=pz(:,n+1:end); %提取原始的自变量、因变量数据
e0=data(:,1:n);f0=data(:,n+1:end);  %提取标准化后的自变量、因变量数据
num=size(e0,1);%求样本点的个数
temp=eye(n);%对角阵
for i=1:n
%以下计算 w，w*和 t 的得分向量，
    matrix=e0'*f0*f0'*e0;
    [vec,val]=eig(matrix); %求特征值和特征向量
    val=diag(val);   %提出对角线元素
    [val,ind]=sort(val,'descend');
    w(:,i)=vec(:,ind(1)); %提出最大特征值对应的特征向量
    t(:,i)=e0*w(:,i);     %计算成分 ti 的得分
    alpha(:,i)=e0'*t(:,i)/(t(:,i)'*t(:,i)) ;%计算 alpha_i ,其中(t(:,i)'*t(:,i))等价于norm(t(:,i))^2
    e=e0-t(:,i)*alpha(:,i)' ;   %计算残差矩阵
    e0=e;
     %计算w*矩阵
       if i==1
           w_star(:,i)=w(:,i);
       else
          for j=1:i-1
              temp=temp*(eye(n)-w(:,j)*alpha(:,j)');
          end
          w_star(:,i)=temp*w(:,i);
       end   
%****************** 交叉有效性选取主成分个数(不是很好用，可自己更改r) **************************8
%以下计算 ss(i)的值
    beta=[t(:,1:i),ones(num,1)]\f0  %求回归方程的系数
    beta(end,:)=[];   %删除回归分析的常数项
    cancha=f0-t(:,1:i)*beta;    %求残差矩阵
    ss(i)=sum(sum(cancha.^2));  %求误差平方和
%以下计算 press(i)
    for j=1:num
        t1=t(:,1:i);f1=f0;
        she_t=t1(j,:);she_f=f1(j,:);  %把舍去的第 j个样本点保存起来
        t1(j,:)=[];f1(j,:)=[];        %删除第j个观测值
        beta1=[t1,ones(num-1,1)]\f1;  %求回归分析的系数
        beta1(end,:)=[];           %删除回归分析的常数项
        cancha=she_f-she_t*beta1;  %求残差向量
        press_i(j)=sum(cancha.^2); 
    end
    press(i)=sum(press_i)
    if i>1
        Q_h2(i)=1-press(i)/ss(i-1)
    else
        Q_h2(1)=1
    end
    if Q_h2(i)<0.0985
        fprintf('提出的成分个数 r=%d',i);
        r=i;
        break
    end
%***********************************************************************
end
beta_z=[t(:,1:r),ones(num,1)]\f0;   %求标准化Y关于 t 的回归系数
beta_z(end,:)=[];      %删除常数项
xishu=w_star(:,1:r)*beta_z;   %求标准化Y关于X的回归系数， 且是针对标准数据的回归系数，每一列是一个回归方程
mu_x=aver(1:n);mu_y=aver(n+1:end);
sig_x=stdcov(1:n);sig_y=stdcov(n+1:end);
for i=1:m
    ch0(i)=mu_y(i)-mu_x./sig_x*sig_y(i)*xishu(:,i);  %计算原始数据的回归方程的常数项
end
for i=1:m
    xish(:,i)=xishu(:,i)./sig_x'*sig_y(i);  %计算原始数据的回归方程的系数， 每一列是一个回归方程
end
sol=[ch0;xish]      %显示回归方程的系数，每一列是一个方程，每一列的第一个数是常数项
y=sol;