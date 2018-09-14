
function y=pls(X,Y,r)
%************  pls() **************
%说明：输入数据X,Y,X为辅助变量，Y为主导变量维数,r为成分个数
pz=[X,Y];
[row,~]=size(pz);
aver=mean(pz);
stdcov=std(pz); %求均值和标准差
rr=corrcoef(pz);   %求相关系数矩阵
data=zscore(pz); %数据标准化
stdarr = ( pz - aver(ones(row,1),:) )./ stdcov( ones(row,1),:);  % 标准化自变量
n=size(X,2);m=size(Y,2);   %n 是自变量的个数,m是因变量的个数
x0=pz(:,1:n);y0=pz(:,n+1:end); %提取原始的自变量、因变量数据
e0=data(:,1:n);f0=data(:,n+1:end);  %提取标准化后的自变量、因变量数据
num=size(e0,1);%求样本点的个数
temp=eye(n);%对角阵
for i=1:n
%以下计算 w，w*和 t 的得分向量，
    matrix=e0'*f0*f0'*e0;
    [vec,val]=eig(matrix); %求特征值和特征向量
    val=diag(val);   %提出对角线元素
    [~,ind]=sort(val,'descend');
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
sol=[ch0;xish] ;     %显示回归方程的系数，每一列是一个方程，每一列的第一个数是常数项
y=sol;