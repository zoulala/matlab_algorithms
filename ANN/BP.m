function main()
SamNum=100;%ѵ��������
TestSamNum=101;%����������
HiddenUnitNum=10;%���ڵ���
InDim=1;%��������ά��
OutDim=1;%���ά��
%������һ������
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
%����BP�㷨�������ƽ�����ĺ�����������������������������������������������������
MaxEpochs=20000;%���ѵ������
lr=0.003;%ѧϰ��
E0=0.5;%Ŀ�����

W1=0.2*rand(HiddenUnitNum,InDim)-0.1;%����㵽����ĳ�ʼȨֵ
B1=0.2*rand(HiddenUnitNum,1)-0.1;%���ڵ��ʼ��ֵ
W2=0.2*rand(OutDim,HiddenUnitNum)-0.1;%���㵽�����ĳ�ʼȨֵ
B2=0.2*rand(OutDim,1)-0.1;%������ʼ��ֵ

W1Ex=[W1 B1];%����㵽����ĳ�ʼȨֵ��չ
W2Ex=[W2 B2];%���㵽�����ĳ�ʼȨֵ��չ

SamInEx=[SamIn' ones(SamNum,1)]';%����������չ
ErrHistory=[];%��¼Ȩֵ�������ѵ�����
for i=1:MaxEpochs
    %�����������������
    HiddenOut=logsig(W1Ex*SamInEx);
    HiddenOutEx=[HiddenOut' ones(SamNum,1)]';
    NetworkOut=W2Ex*HiddenOutEx;
    %�ж�ѵ���Ƿ�ֹͣ
    Error=SamOut-NetworkOut;
    SSE=sumsqr(Error)
    %��¼ÿ��Ȩֵ�������ѵ�����
    ErrHistory=[ErrHistory SSE];
    
    if SSE<E0,break,end
    %���㷴�򴫲����
    Delta2=Error;
    Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);
    %����Ȩֵ������
    dW2Ex=Delta2*HiddenOutEx';
    dW1Ex=Delta1*SamInEx';
    %Ȩֵ����
    W1Ex=W1Ex+lr*dW1Ex;
    W2Ex=W2Ex+lr*dW2Ex;
    %�������㵽������Ȩֵ
    W2=W2Ex(:,1:HiddenUnitNum);
end
%������ʾ������
i
W1=W1Ex(:,1:InDim)
B1=W1Ex(:,InDim+1)
W2
B2=W2Ex(:,1+HiddenUnitNum);
%����
TestHiddenOut=logsig(W1*TestSamIn+repmat(B1,1,TestSamNum));
TestNNOut=W2*TestHiddenOut+repmat(B2,1,TestSamNum);
figure
plot(TestSamIn,TestNNOut,'k-');
xlabel('Input TestSamIn');
ylabel('Output TestNNOut');
%����ѧϰ�������
figure
hold on
grid
[xx,Num]=size(ErrHistory);
plot(1:Num,ErrHistory,'K-');