%�����ع�����ģ&&Ԥ��
clc;clear;close all
[num,text,raw]=xlsread('D:\workspace\�����豸����\xi_test','sheet1');%n_start= 60;n_end  = 410;
%     [num,text,raw]=xlsread('C:\Users\Administrator\Desktop\data\zou_test','Sheet3');%n_start= 50;n_end  = 400;

% [num,text,raw]=xlsread('D:\workspace\���ݻ���3��-4��\����\lin\lin_hanna004','sheet1');
% [num,text,raw]=xlsread('D:\workspace\���ݻ���3��-4��\����\pan\pan_hanna001','sheet1');
% [num,text,raw]=xlsread('D:\workspace\���ݻ���3��-4��\����\ding\ding_hanna002','sheet1');
% [num,text,raw]=xlsread('D:\workspace\���ݻ���3��-4��\����\wei\wei_hanna004','sheet1');
% [num,text,raw]=xlsread('D:\workspace\���ݻ���3��-4��\����\zou\zou_hanna004','sheet1');
% x=data(:,2:end);
% % x=zscore(x);
% y=data(:,1);

n_r=4;
% %------- �������ݴ洢��ʽ �жϼ������� --------
len_all=length(num(3,:));
k=ceil(len_all/n_r);    % k����   ��

%-------              ����           ---------
lev_r=2;     %С���ֽ����
n_start= 60;
n_end  = 410;

ERR=0.3;%�����ع���ѵ�����
ECHO=100;%�����ع���ѵ�������
k_r=0.8;%ѵ������ռ����

mean_n=10; %ȡƽ�����ĸ���
sm_flag=2; %�����˲�����

%--------            ѭ������    ------------
% k=9;
pre_glu=zeros(k,1);
for i=1:k
y(i)=cell2mat(raw(2,n_r*(i-1)+n_r));% ��ʵѪ��ֵ


 start_940=1;
 start_850=1;
    
    
    x0_940=num(:,n_r*(i-1)+3);x0_940(isnan(x0_940))=[];
    x0_850=num(:,n_r*(i-1)+2);x0_850(isnan(x0_850))=[]; 
    
    for j=1:length(x0_940)-13
        if(x0_940(j+11)<55000&&x0_940(j+12)<55000&&x0_940(j+13)<55000&&(x0_940(j+11)-x0_940(j))>2000&&(x0_940(j+12)-x0_940(j+1))>2000&&(x0_940(j+13)-x0_940(j+2))>2000&&x0_940(j)>2000&&x0_940(j+1)>2000&&x0_940(j+2)>2000)
            start_940=j;
            break;
        end
    end
    for j=1:length(x0_850)-13
        if(x0_850(j+11)<55000&&x0_850(j+12)<55000&&x0_850(j+13)<55000&&(x0_850(j+11)-x0_850(j))>2000&&(x0_850(j+12)-x0_850(j+1))>2000&&(x0_850(j+13)-x0_850(j+2))>2000&&x0_850(j)>2000&&x0_850(j+1)>2000&&x0_850(j+2)>2000)
            start_850=j;
            break;
        end
    end
    
%     d_940=diff(x0_940);
%     d_850=diff(x0_850);
%     start_940=find(d_940==max(d_940));start_940=start_940(1);
%     start_850=find(d_850==max(d_850));start_850=start_850(1);    
%     
%   ***************  ��ȡ��i��˫�������� ***************
%      y(i)=cell2mat(raw(2,r*(i-1)+4));% ��ʵѪ��ֵ
    x_940=x0_940(start_940:end);
    x_850=x0_850(start_850:end); 

% 
% %   ***************  ��ȡ��i��˫��������   
    sm_940=[];sm_850=[];
if sm_flag==1
    [C,L]=wavedec(x_940,lev_r,'db5');%
    sm_940=wrcoef('a',C,L,'db5',lev_r);%�ع���3���Ƶ���֣�a��Ƶ��d��Ƶ
    
    [C,L]=wavedec(x_850,lev_r,'db5');%
    sm_850=wrcoef('a',C,L,'db5',lev_r);%�ع���3���Ƶ���֣�a��Ƶ��d��Ƶ
elseif sm_flag==2    
    for j=1:length(x_940)-mean_n
        sm_940(j)=mean(x_940(j:j+mean_n));
    end
    for j=1:length(x_850)-mean_n
        sm_850(j)=mean(x_850(j:j+mean_n));
    end
    sm_940=[zeros(1,ceil(mean_n/2)),sm_940];
    sm_850=[zeros(1,ceil(mean_n/2)),sm_850];
end
    
    plot(x_850)
    hold on;
    plot(sm_850);


        len_min=min(length(sm_940),length(sm_850));  %˫�������ݵ��� ���ٵ�һ��
        if n_end>len_min
            n_end=len_min;
        end
        amp_log940=log(sm_940(n_end)/sm_940(n_start));
        amp_log850=log(sm_850(n_end)/sm_850(n_start));
        amp_940=(sm_940(n_end)-sm_940(n_start))/sm_940(n_start);
        amp_850=(sm_850(n_end)-sm_850(n_start))/sm_850(n_start);
%         b=[3,-100,2];
%         load b;
%         pre_glu(i)=amp_log940/amp_log850;
        feature_x(i,:)=[amp_log940,amp_log850];
%         feature_x(i,:)=[amp_log940,amp_log850,amp_log940^2,amp_log850^2,amp_940,amp_850];
%         pre_glu(i)=b(1)*amp_log940+b(2)*amp_log850+b(3);   

end


x=feature_x;
y=y';

%����������
t=randperm(k);
xtr=t(1:floor(k*k_r));
xpr=t(floor(k*k_r)+1:end);

A1=x(xtr,:);
C1=y(xtr,:);
A2=x(xpr,:);
C2=y(xpr,:);

CUT=boostree_model(A1,C1,ERR,ECHO);%��ģ
Y=boostree_pre(A2,CUT); %Ԥ��

%------------------------------- ��ͼ ----------------------------------
figure;
plot(C2,'*-');
hold on;
plot(Y,'*-');
legend('real','predict');
[total,percent]=clarke(C2*18, Y*18);

