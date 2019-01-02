function main()
SamNum=100;%ѵ��������
TestSamNum=101;%����������
ClusterNum=10;%���ڵ���
InDim=1;%��������ά��
Overlap=1.0;%���ڵ��ص�ϵ��
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
plot(SamIn,SamOut,'k+')
figure
plot(TestSamIn,TestSamOut,'k-')
xlabel('Input x');
ylabel('Output y');
%����RBF�㷨�������ƽ�����ĺ�����������������������������������������������������
Centers=SamIn(:,1:ClusterNum);%��ʼ10������ȡ�������ǰ10��
NumberInClusters=zeros(ClusterNum,1);%�����е�����������ʼ��Ϊ0
IndexInClusters=zeros(ClusterNum,SamNum);%��������������������
while 1,
    NumberInClusters=zeros(ClusterNum,1);%�����е�����������ʼ��Ϊ0
    IndexInClusters=zeros(ClusterNum,SamNum);%��������������������
    %����С����ԭ��������������з���
    for i=1:SamNum
        AllDistance=dist(Centers',SamIn(:,i));
        [MinDist,Pos]=min(AllDistance);
        NumberInClusters(Pos)=NumberInClusters(Pos)+1;
        IndexInClusters(Pos,NumberInClusters(Pos))=i;
    end
    %����ɵľ�������
    OldCenters=Centers;
    %���¼������ľ�������
    for i=1:ClusterNum
        Index=IndexInClusters(i,1:NumberInClusters(i));
        Centers(:,i)=mean(SamIn(:,Index)')';
    end
    %�ж��¾ɾ��������Ƿ�һ�£������������
    EqualNum=sum(sum(Centers==OldCenters));
    if EqualNum==InDim*ClusterNum,
       break,end
end
%��������ڵ����չ����
AllDistances=dist(Centers',Centers);%�������ڵ��������ļ�ľ��루����
Maximum=max(max(AllDistances));%�ҳ���������һ������
for i=1:ClusterNum
    AllDistances(i,i)=Maximum+1;
end
Spreads=Overlap*min(AllDistances)'%�����ڵ�����С������Ϊ��չ����
%��������ڵ�����Ȩֵ,����С���˷�
Distance=dist(Centers',SamIn);%�����������������������ĵľ���
SpreadsMat=repmat(Spreads,1,SamNum);
HiddenUnitOut=radbas(Distance./SpreadsMat);%�������ڵ������
HiddenUnitOutEx=[HiddenUnitOut' ones(SamNum,1)]';%������ֵ
W2Ex=SamOut*pinv(HiddenUnitOutEx);%��������Ȩֵ
W2=W2Ex(:,1:ClusterNum);%���Ȩֵ
B2=W2Ex(:,ClusterNum+1);%��ֵ
%����
TestDistance=dist(Centers',TestSamIn);
TestSpreadsMat=repmat(Spreads,1,TestSamNum);
TestHiddenUnitOut=radbas(TestDistance./TestSpreadsMat);
TestNNOut=W2*TestHiddenUnitOut+B2;
figure
plot(TestSamIn,TestNNOut,'k--')
W2
B2