function main()
SamNum=100;%训练样本数
TestSamNum=101;%测试样本数
HiddenUnitNum=10;%隐节点数
InDim=1;%输入样本维数
OutDim=1;%输出维数
%下面是一个函数
rand('state',sum(100*clock))
NoiseVar=0.1;
Noise=NoiseVar*randn(1,SamNum);
SamIn=8*rand(1,SamNum)-4;
SamOutNoNoise=1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
SamOut=SamOutNoNoise+Noise;

TestSamIn=-4:0.08:4;
TestSamOut=1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);

figure
hold on
grid
plot(SamIn,SamOut,'k*')
figure
plot(TestSamIn,TestSamOut,'k--')
xlabel('Input x');
ylabel('Output y');
%以下BP算法是用来逼近上面的函数。。。。。。。。。。。。。。。。。。。。。。。。。
MaxEpochs=20000;%最大训练次数
lr=0.003;%学习率
E0=0.5;%目标误差

W1=0.2*rand(HiddenUnitNum,InDim)-0.1;%输入层到隐层的初始权值
B1=0.2*rand(HiddenUnitNum,1)-0.1;%隐节点初始阈值
W2=0.2*rand(OutDim,HiddenUnitNum)-0.1;%隐层到输出层的初始权值
B2=0.2*rand(OutDim,1)-0.1;%输出层初始阈值

W1Ex=[W1 B1];%输入层到隐层的初始权值扩展
W2Ex=[W2 B2];%隐层到输出层的初始权值扩展

SamInEx=[SamIn' ones(SamNum,1)]';%输入样本扩展
ErrHistory=[];%记录权值调整后的训练误差
for i=1:MaxEpochs
    %正向计算网络各层输出
    HiddenOut=logsig(W1Ex*SamInEx);
    HiddenOutEx=[HiddenOut' ones(SamNum,1)]';
    NetworkOut=W2Ex*HiddenOutEx;
    %判断训练是否停止
    Error=SamOut-NetworkOut;
    SSE=sumsqr(Error)
    %记录每次权值调整后的训练误差
    ErrHistory=[ErrHistory SSE];
    
    if SSE<E0,break,end
    %计算反向传播误差
    Delta2=Error;
    Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);
    %计算权值调整量
    dW2Ex=Delta2*HiddenOutEx';
    dW1Ex=Delta1*SamInEx';
    %权值调整
    W1Ex=W1Ex+lr*dW1Ex;
    W2Ex=W2Ex+lr*dW2Ex;
    %分离隐层到输出层的权值
    W2=W2Ex(:,1:HiddenUnitNum);
end
%以下显示计算结果
i
W1=W1Ex(:,1:InDim)
B1=W1Ex(:,InDim+1)
W2
B2=W2Ex(:,1+HiddenUnitNum);
%测试
TestHiddenOut=logsig(W1*TestSamIn+repmat(B1,1,TestSamNum));
TestNNOut=W2*TestHiddenOut+repmat(B2,1,TestSamNum);
figure
plot(TestSamIn,TestNNOut,'k-');
xlabel('Input TestSamIn');
ylabel('Output TestNNOut');
%绘制学习误差曲线
figure
hold on
grid
[xx,Num]=size(ErrHistory);
plot(1:Num,ErrHistory,'K-');