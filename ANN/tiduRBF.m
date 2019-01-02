SamNum = 100; % 训练样本数
TargetSamNum = 101; % 测试样本数
InDim = 1; % 样本输入维数
UnitNum = 10; % 隐节点数
MaxEpoch = 5000; % 最大训练次数
E0 = 0.9; % 目标误差
% 根据目标函数获得样本输入输出
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
lrCent = 0.001; % 隐节点数据中心学习系数
lrSP = 0.001; % 隐节点扩展常数学习系数
lrW = 0.001; % 隐节点输出权值学习系数
ErrHistory = []; % 用于记录每次参数调整后的训练误差
for epoch = 1:MaxEpoch
AllDist = dist(Center',SamIn);
SPMat = repmat(SP',1,SamNum);
UnitOut = radbas(AllDist./SPMat);
NetOut = W*UnitOut;
Error = SamOut-NetOut;
%停止学习判断
SSE = sumsqr(Error)
% 记录每次权值调整后的训练误差
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
% 测试
TestDistance = dist(Center',TargetIn);
TestSpreadsMat = repmat(SP',1,TargetSamNum);
TestHiddenUnitOut = radbas(TestDistance./TestSpreadsMat);
TestNNOut = W*TestHiddenUnitOut;
plot(TargetIn,TestNNOut,'k-')
% 绘制学习误差曲线
figure
hold on
grid
[xx,Num] = size(ErrHistory);
plot(1:Num,ErrHistory,'k-');
