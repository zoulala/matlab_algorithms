%--------------���������BP�㷨-------------%
clear all;
SamNum=100;%������
TestSamNum=100;%��������
HiddenUnit1Num=10;%����1�����
HiddenUnit2Num=10;%����2�ڵ���
InDim=1;%��������ά��
OutDim=1;%�������ά��
%����Ŀ�꺯����������������
SamIn=8*rand(1,SamNum)-4;%������������
SamOut=1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);%Ŀ�����
TestSamIn=-4:0.08:4;%��������
TestSamOut=1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);%��������Ŀ�����
MaxEpochs=20000;%���ѵ������
lr=0.003;%ѧϰ��
E0=0.05;%Ŀ�����
W1=0.2*rand(HiddenUnit1Num,InDim)-0.1;
B1=0.2*rand(HiddenUnit1Num,1)-0.1;
W2=0.2*rand(HiddenUnit2Num,HiddenUnit1Num)-0.1;
B2=0.2*rand(HiddenUnit2Num,1)-0.1;
W3=0.2*rand(OutDim,HiddenUnit2Num)-0.1;
B3=0.2*rand(OutDim,1)-0.1;
%������չ����������չ��������%
W1Ex=[W1 B1];
W2Ex=[W2 B2];
W3Ex=[W3 B3];
SamInEx=[SamIn' ones(SamNum,1)]';
Dw1Ex=zeros(HiddenUnit1Num,InDim+1);
Dw2Ex=zeros(HiddenUnit2Num,HiddenUnit1Num+1);
Delta2Store=zeros(HiddenUnit2Num,SamNum);
for i=1:MaxEpochs
    %���򴫲�ʱ��һ���㣬�ڶ����㣬���������ֵ%
    u=W1Ex*SamInEx;
    Hidden1Out=1./(1+exp(-u));
    Hidden1OutEx=[Hidden1Out' ones(SamNum,1)]';
    u=W2Ex*Hidden1OutEx;
    Hidden2Out=1./(1+exp(-u));
    Hidden2OutEx=[Hidden2Out' ones(SamNum,1)]';
    NetworkOut=W3Ex*Hidden2OutEx;   %�������ֵ
    %ֹͣѧϰ�ж�����
    Error=SamOut-NetworkOut;%��һ��1*100������
    SSE=sum(Error.^2);%�����������������֮��
    if SSE<E0,break,end
    %���㷴�򴫲����
    Delta3=Error;%��һ��������������100�����������
    Dw3Ex=Delta3*Hidden2OutEx';
    for n=1:SamNum %��ÿһ�������ֱ����
        Delta2=(W3'*Delta3(n)).*Hidden2Out(:,n).*(1-Hidden2Out(:,n));
        Delta2Store(:,n)=Delta2;
        Dw2Ex=Dw2Ex+Delta2*Hidden1OutEx(:,n)'; 
    end
    for m=1:SamNum%��ÿһ�������ֱ����
        Delta1=((Delta2Store(:,m)'*W2)').*Hidden1Out(:,m).*(1-Hidden1Out(:,m));
        Dw1Ex=Dw1Ex+Delta1*(SamInEx(:,m))';
    end
    %����Ȩֵ
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
TestNetworkOut=W3Ex*Hidden2OutEx;   %�������ֵ
plot(TestSamIn,TestNetworkOut,TestSamIn,TestSamOut);
