% BP ����������Ԥ��
% ʹ��ƽ̨ - Matlab7.0
% ����Ϊ1986�굽2000��Ľ�ͨ�� ������Ϊ3���룬1���
% 15�����ݣ�����9��Ϊ����ѵ�����ݣ�3��Ϊ�������ݣ�3��Ϊ��������
%by akjuan
%all rights preserved by www.4math.cn
%2008.11

clc
clear

%---------------------------------------------------
%ԭʼ����
%---------------------------------------------------
year=1986:2000;%�����Ǵ�1986��2000���

p=[493 372 445;372 445 176;445 176 235;176 235 378;235 378 429;...
378 429 561;429 561 651;561 651 467;651 467 527;467 527 668;...
527 668 841; 668 841 526;841 526 480;526 480 567;480 567 685]';%�������ݣ���15�飬ÿ��3������
t=[176 235 378 429 561 651 467 527 668 841 526 480 567 685 507];%������ݣ���15�飬ÿ��1�����


%---------------------------------------------------
%���ݹ�һ������
%mapminmax����Ĭ�Ͻ����ݹ�һ����[-1,1]��������ʽ����
%[y,ps] =%mapminmax(x,ymin,ymax)
%x��黯����������
%ymin��ymaxΪ��黯���ķ�Χ������Ĭ��Ϊ�黯��[-1,1]
%y��һ�������������
%ps�������ã�ps��Ҫ�ڽ������һ������Ҫ���ã�����ʹ��ͬ����settings��һ������һ������
%---------------------------------------------------
[normInput,ps] = mapminmax(p);
[normTarget,ts] = mapminmax(t);


%---------------------------------------------------
%�������򣬼����ദ��
%�������15�����ݵ�20%����3�飬������Ϊ�������ݣ�
% ������20%����3�飬������Ϊ�仯���ݣ�
%����9�������������룬����ѵ����
%dividevec()�������������ȡ�������ַ�������ݣ�ԭ����˳�򱻴���
%�������õ��﷨
%[trainV,valV,testV] = dividevec(p,t,valPercent,testPercent)
%����pΪ�������ݣ�tΪ�������
%valPercentΪѵ���õı仯�������������еİٷֱ�
%testPercentΪѵ���õĲ����������������еİٷֱ�
%���trainV,valV,testV�ֱ�Ϊ��������Ӧ�ٷֱȣ���ȡ�õ�������
%���⣬���Һ�����ݣ�p��t���Ƕ�Ӧ�ģ������ʹ��
%---------------------------------------------------
testPercent = 0.20; % Adjust as desired
validatePercent = 0.20; % Adust as desired
[trainSamples,validateSamples,testSamples] = dividevec(normInput,normTarget,validatePercent,testPercent);


%---------------------------------------------------
% �����������
%--------------------------------------------------- 
NodeNum1 = 20; % �����һ��ڵ���
NodeNum2=40; % ����ڶ���ڵ���
TypeNum = 1; % ���ά��

TF1 = 'tansig';TF2 = 'tansig'; TF3 = 'tansig';%���㴫�亯����TF3Ϊ����㴫�亯��
%���ѵ����������룬���Գ��Ը��Ĵ��亯����������Щ�Ǹ��ഫ�亯��
%TF1 = 'tansig';TF2 = 'logsig';
%TF1 = 'logsig';TF2 = 'purelin';
%TF1 = 'tansig';TF2 = 'tansig';
%TF1 = 'logsig';TF2 = 'logsig';
%TF1 = 'purelin';TF2 = 'purelin'; 

%ע�ⴴ��BP���纯��newff()�Ĳ������ã����°汾(7.6)���Ѹı�
net=newff(minmax(normInput),[NodeNum1,NodeNum2,TypeNum],{TF1 TF2 TF3},'traingdx');%�����Ĳ�BP����



%---------------------------------------------------
% ����ѵ������
%--------------------------------------------------- 
net.trainParam.epochs=10000;%ѵ����������
net.trainParam.goal=1e-6;%ѵ��Ŀ������
net.trainParam.lr=0.01;%ѧϰ������,Ӧ����Ϊ����ֵ��̫����Ȼ���ڿ�ʼ�ӿ������ٶȣ����ٽ���ѵ�ʱ�����������������ʹ�޷�����
%---------------------------------------------------
% ָ��ѵ������
%---------------------------------------------------
% net.trainFcn = 'traingd'; % �ݶ��½��㷨
% net.trainFcn = 'traingdm'; % �����ݶ��½��㷨
%
% net.trainFcn = 'traingda'; % ��ѧϰ���ݶ��½��㷨
% net.trainFcn = 'traingdx'; % ��ѧϰ�ʶ����ݶ��½��㷨
%
% (�����������ѡ�㷨)
% net.trainFcn = 'trainrp'; % RPROP(����BP)�㷨,�ڴ�������С
%
% (�����ݶ��㷨)
% net.trainFcn = 'traincgf'; % Fletcher-Reeves�����㷨
% net.trainFcn = 'traincgp'; % Polak-Ribiere�����㷨,�ڴ������Fletcher-Reeves�����㷨�Դ�
% net.trainFcn = 'traincgb'; % Powell-Beal��λ�㷨,�ڴ������Polak-Ribiere�����㷨�Դ�
%
% (�����������ѡ�㷨)
%net.trainFcn = 'trainscg'; % Scaled Conjugate Gradient�㷨,�ڴ�������Fletcher-Reeves�����㷨��ͬ,�����������������㷨��С�ܶ�
% net.trainFcn = 'trainbfg'; % Quasi-Newton Algorithms - BFGS Algorithm,���������ڴ�������ȹ����ݶ��㷨��,�������ȽϿ�
% net.trainFcn = 'trainoss'; % One Step Secant Algorithm,���������ڴ��������BFGS�㷨С,�ȹ����ݶ��㷨�Դ�
%
% (�����������ѡ�㷨)
%net.trainFcn = 'trainlm'; % Levenberg-Marquardt�㷨,�ڴ��������,�����ٶ����
% net.trainFcn = 'trainbr'; % ��Ҷ˹�����㷨
%
% �д����Ե������㷨Ϊ:'traingdx','trainrp','trainscg','trainoss', 'trainlm'

net.trainfcn='traingdm';
[net,tr] = train(net,trainSamples.P,trainSamples.T,[],[],validateSamples,testSamples);

%---------------------------------------------------
% ѵ����ɺ󣬾Ϳ��Ե���sim()���������з�����
%--------------------------------------------------- 
[normTrainOutput,Pf,Af,E,trainPerf] = sim(net,trainSamples.P,[],[],trainSamples.T);%���������9��p���ݣ�BP�õ��Ľ��t
[normValidateOutput,Pf,Af,E,validatePerf] = sim(net,validateSamples.P,[],[],validateSamples.T);%��������3������p��BP�õ��Ľ��t
[normTestOutput,Pf,Af,E,testPerf] = sim(net,testSamples.P,[],[],testSamples.T);%�������Ե�3������p��BP�õ��Ľ��t


%---------------------------------------------------
% ����������ݷ���һ���������ҪԤ�⣬ֻ�轫Ԥ�������P����
% �����Ԥ����t
%--------------------------------------------------- 
trainOutput = mapminmax('reverse',normTrainOutput,ts);%���������9��p���ݣ�BP�õ��Ĺ�һ����Ľ��t
trainInsect = mapminmax('reverse',trainSamples.T,ts);%���������9������t
validateOutput = mapminmax('reverse',normValidateOutput,ts);%��������3������p��BP�õ��Ĺ�һ���Ľ��t
validateInsect = mapminmax('reverse',validateSamples.T,ts);%��������3������t
testOutput = mapminmax('reverse',normTestOutput,ts);%��������3������p��BP�õ��Ĺ�һ���Ľ��t
testInsect = mapminmax('reverse',testSamples.T,ts);%��������3������t


%---------------------------------------------------
% ���ݷ����ͻ�ͼ
%--------------------------------------------------- 
figure
plot(1:12,[trainOutput validateOutput],'b-',1:12,[trainInsect validateInsect],'g--',13:15,testOutput,'m*',13:15,testInsect,'ro');
title('oΪ��ʵֵ��*ΪԤ��ֵ')
xlabel('���');
ylabel('��ͨ��������/��ҹ��');