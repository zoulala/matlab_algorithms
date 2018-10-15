%*************** k-近邻预估程序 ******************

%取距离最小的前3个，进行加权求和
%***********************************

clc;clear;close all;
[num,txt,raw]=xlsread('C:\Users\Administrator\Desktop\本科毕业设计数据.xlsx','sheet1');
num(:,1)=[];
[n,m]=size(num);
x=num(:,1:m-1);
y=num(:,m);

n1=n*0.8;
x1=x(1:n1,:);%样本数据
x2=x(n1+1:end,:);%测试数据

for i=1:n-n1
    for j=1:n1
        a(i,j)=sqrt(sum((x2(i,:)-x1(j,:)).^2));%计算测试数据与样本数据间的距离    
    end
    [b,c]=sort(a(i,:));%对距离排序
    y_pr(i)=0.5*y(c(1))+0.3*y(c(2))+0.2*y(c(3));%距离最近的3个点进行加权预估
end
%[b,c]=sort(a,2);%对距离进行排序，c为排序后的序号
figure;
plot(y(n1+1:end),'b.-');title('k-近邻预估');
hold on;
plot(y_pr,'ro-');
hold off;
legend('真实值','预估值');
axis([1 6 0 10]);
disp('均方根误差：');
ess=sqrt(sum((y(n1+1:end)'-y_pr).^2)/(n-n1))
