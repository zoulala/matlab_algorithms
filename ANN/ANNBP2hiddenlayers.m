%--------------两个隐层的BP算法-------------%
clear all;
SamNum=100;%样本数
TestSamNum=100;%测试样本
HiddenUnit1Num=10;%隐层1结点数
HiddenUnit2Num=10;%隐层2节点数
InDim=1;%样本输入维数
OutDim=1;%样本输出维数
%根据目标函数获得样本输入输出
SamIn=8*rand(1,SamNum)-4;%产生样本向量
SamOut=1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);%目标输出
TestSamIn=-4:0.08:4;%测试数据
TestSamOut=1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);%测试数据目标输出
MaxEpochs=20000;%最大训练次数
lr=0.003;%学习率
E0=0.05;%目标误差
W1=0.2*rand(HiddenUnit1Num,InDim)-0.1;
B1=0.2*rand(HiddenUnit1Num,1)-0.1;
W2=0.2*rand(HiddenUnit2Num,HiddenUnit1Num)-0.1;
B2=0.2*rand(HiddenUnit2Num,1)-0.1;
W3=0.2*rand(OutDim,HiddenUnit2Num)-0.1;
B3=0.2*rand(OutDim,1)-0.1;
%产生扩展向量，及扩展样本输入%
W1Ex=[W1 B1];
W2Ex=[W2 B2];
W3Ex=[W3 B3];
SamInEx=[SamIn' ones(SamNum,1)]';
Dw1Ex=zeros(HiddenUnit1Num,InDim+1);
Dw2Ex=zeros(HiddenUnit2Num,HiddenUnit1Num+1);
Delta2Store=zeros(HiddenUnit2Num,SamNum);
for i=1:MaxEpochs
    %正向传播时第一隐层，第二隐层，及网络输出值%
    u=W1Ex*SamInEx;
    Hidden1Out=1./(1+exp(-u));
    Hidden1OutEx=[Hidden1Out' ones(SamNum,1)]';
    u=W2Ex*Hidden1OutEx;
    Hidden2Out=1./(1+exp(-u));
    Hidden2OutEx=[Hidden2Out' ones(SamNum,1)]';
    NetworkOut=W3Ex*Hidden2OutEx;   %网络输出值
    %停止学习判断条件
    Error=SamOut-NetworkOut;%是一个1*100的向量
    SSE=sum(Error.^2);%所有样本产生的误差之和
    if SSE<E0,break,end
    %计算反向传播误差
    Delta3=Error;%是一个横向量，包含100个样本的误差
    Dw3Ex=Delta3*Hidden2OutEx';
    for n=1:SamNum %对每一个样本分别计算
        Delta2=(W3'*Delta3(n)).*Hidden2Out(:,n).*(1-Hidden2Out(:,n));
        Delta2Store(:,n)=Delta2;
        Dw2Ex=Dw2Ex+Delta2*Hidden1OutEx(:,n)'; 
    end
    for m=1:SamNum%对每一个样本分别计算
        Delta1=((Delta2Store(:,m)'*W2)').*Hidden1Out(:,m).*(1-Hidden1Out(:,m));
        Dw1Ex=Dw1Ex+Delta1*(SamInEx(:,m))';
    end
    %更新权值
    W1Ex=W1Ex+lr*Dw1Ex;
    W2Ex=W2Ex+lr*Dw2Ex;
    W3Ex=W3Ex+lr*Dw3Ex;
    W2=W2Ex(:,1:HiddenUnit1Num);
    W3=W3Ex(:,1:HiddenUnit2Num);
    Delta2Store=zeros(HiddenUnit2Num,SamNum);
    Dw1Ex=zeros(HiddenUnit1Num,InDim+1);
    Dw2Ex=zeros(HiddenUnit2Num,HiddenUnit1Num+1);
end
v=size(TestSamIn);
TestSamInEx=[TestSamIn' ones(v(2),1)]';
u=W1Ex*TestSamInEx;
Hidden1Out=1./(1+exp(-u));
Hidden1OutEx=[Hidden1Out' ones(v(2),1)]';
u=W2Ex*Hidden1OutEx;
Hidden2Out=1./(1+exp(-u));
Hidden2OutEx=[Hidden2Out' ones(v(2),1)]';
TestNetworkOut=W3Ex*Hidden2OutEx;   %网络输出值
plot(TestSamIn,TestNetworkOut,TestSamIn,TestSamOut);
