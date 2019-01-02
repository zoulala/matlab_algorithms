SamNum = 100; % ѵ��������
TargetSamNum = 101; % ����������
InDim = 1; % ��������ά��
UnitNum = 10; % ���ڵ���
MaxEpoch = 5000; % ���ѵ������
E0 = 0.9; % Ŀ�����
% ����Ŀ�꺯����������������
rand('state',sum(100*clock))
NoiseVar = 0.1;
Noise = NoiseVar*randn(1,SamNum);
SamIn = 8*rand(1,SamNum)-4;
SamOutNoNoise = 1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
SamOut = SamOutNoNoise + Noise;
TargetIn = -4:0.08:4;
TargetOut = 1.1*(1-TargetIn+2*TargetIn.^2).*exp(-TargetIn.^2/2);
figure
hold on
grid
plot(SamIn,SamOut,'k+')
plot(TargetIn,TargetOut,'k--')
xlabel('Input x');
ylabel('Output y');
Center = 8*rand(InDim,UnitNum)-4;
SP = 0.2*rand(1,UnitNum)+0.1;
W = 0.2*rand(1,UnitNum)-0.1;
lrCent = 0.001; % ���ڵ���������ѧϰϵ��
lrSP = 0.001; % ���ڵ���չ����ѧϰϵ��
lrW = 0.001; % ���ڵ����Ȩֵѧϰϵ��
ErrHistory = []; % ���ڼ�¼ÿ�β����������ѵ�����
for epoch = 1:MaxEpoch
AllDist = dist(Center',SamIn);
SPMat = repmat(SP',1,SamNum);
UnitOut = radbas(AllDist./SPMat);
NetOut = W*UnitOut;
Error = SamOut-NetOut;
%ֹͣѧϰ�ж�
SSE = sumsqr(Error)
% ��¼ÿ��Ȩֵ�������ѵ�����
ErrHistory = [ErrHistory SSE];
if SSE<E0, break, end
for i = 1:UnitNum
CentGrad = (SamIn-repmat(Center(:,i),1,SamNum))...
*(Error.*UnitOut(i,:)*W(i)/(SP(i)^2))';
SPGrad = AllDist(i,:).^2*(Error.*UnitOut(i,:)*W(i)/(SP(i)^3))';
WGrad = Error*UnitOut(i,:)';
Center(:,i) = Center(:,i) + lrCent*CentGrad;
SP(i) = SP(i) + lrSP*SPGrad;
W(i) = W(i) + lrW*WGrad;
end
end
% ����
TestDistance = dist(Center',TargetIn);
TestSpreadsMat = repmat(SP',1,TargetSamNum);
TestHiddenUnitOut = radbas(TestDistance./TestSpreadsMat);
TestNNOut = W*TestHiddenUnitOut;
plot(TargetIn,TestNNOut,'k-')
% ����ѧϰ�������
figure
hold on
grid
[xx,Num] = size(ErrHistory);
plot(1:Num,ErrHistory,'k-');
