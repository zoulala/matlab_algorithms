%逻辑回归
%参考：http://blog.csdn.net/hechenghai/article/details/46817031

clear; close all; clc;
 x = [60 70
     65 75
     80 90
     70 60
     55 85
     78 57
     60 61
     90 95
     50 90
     75 58
     80 80
     65 72
     93 84
     74 69
     81 73
     40 38
     51 41
     39 68
     49 62
     51 39
     58 57
     60 53
     30 90
     70 40
     20 30
     40 86
     90 40
     55 72
     79 48
     42 85]; %每一行是一个样本
 y = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
 
 [m, n] = size(x);
 sample_num = m;
 x =zscore(x);
x = [ones(m, 1), x]; %x增加一维。因为前面文字或前几节说了

% Plot the training data
 % Use different markers for positives and negatives
figure;
pos = find(y == 1); neg = find(y == 0);%pos 和neg 分别是 y元素=1和0的所在的位置序号组成的向量
 plot(x(pos, 2), x(pos,3), '+')%用+表示那些yi=1所对应的样本
 hold on
 plot(x(neg, 2), x(neg, 3), 'o')
 hold on
 xlabel('Exam 1 score')
 ylabel('Exam 2 score')
 itera_num=500;%迭代次数
 g = inline('1.0 ./ (1.0 + exp(-z))','z'); %这个就相当于制造了一个function g（z）=1.0 ./ (1.0 + exp(-z))
 plotstyle = {'b-', 'r-', 'g-', 'k-', 'b--', 'r--'};
 figure;%建立新的窗口
 alpha = [ 1, 0.0008,0.0007,0.0006,0.0005 ,1.0004 ];%下面就分别用这几个学习速率看看哪个更好
 for alpha_i = 1:length(alpha) %alpha_i是1,2，...6，表示的是学习速率向量和曲线格式向量的坐标：alpha(alpha_i)，plotstyle(alpha_i)
     theta = zeros(n+1, 1);%thera表示样本Xi各个元素叠加的权重系数，这里以向量形式表示，且初始都为0，三维向量
     J = zeros(itera_num, 1);%J是个100*1的向量，第n个元素代表第n次迭代cost function的值（下面用negtive 的对数似然函数，
     %因为是negtive 的，所以是求得极小值）
     for i = 1:itera_num %计算出某个学习速率alpha下迭代itera_num次数后的参数   
         z = x * theta;%这个z是一个列向量，每一个元素是每一个样本Xi的线性叠加和，因为X是所有的样本，因此这里不是一个一个样本算的，
         %而是所有样本一块算的，因此z是一个包含所有样本Xi的线性叠加和的向量。在公式中，是单个样本表示法，而在matlab中都是所有的样本一块来。
         h = g(z);%这个h就是样本Xi所对应的yi=1时，映射的概率。如果一个样本Xi所对应的yi=0时，对应的映射概率写成1-h。
         J(i) =(1/sample_num).*sum(-y.*log(h) - (1-y).*log(1-h));%损失函数的矢量表示法 这里Jtheta是个100*1的列向量。
         grad = (1/sample_num).*x'*(h-y);%这个是向量形式的，我们看到grad在公式中是gradj=1/m*Σ（Y（Xi）-yi）Xij ，写得比较粗略，
         %这里（Y（Xi）-yi）、Xij %都是标量，而在程序中是以向量的形式运算的，所以不能直接把公式照搬，所以要认真看看，代码中相应改变一下。
         theta = theta - alpha(alpha_i).*grad;
     end
     plot(0:itera_num-1, J(1:itera_num),char(plotstyle(alpha_i)),'LineWidth', 2)

          %此处一定要通过char函数来转换因为包用（）索引后得到的还是包cell，

     %所以才要用char函数转换，也可以用{}索引，这样就不用转换了。
     %一个学习速率对应的图像画出来以后再画出下一个学习速率对应的图像。    
     hold on
     if(1 == alpha(alpha_i)) %通过实验发现alpha为0.0013 时效果最好，则此时的迭代后的theta值为所求的值
         theta_best = theta;
     end
 end
 legend('0.0009', '0.001','0.0011','0.0012','0.0013' ,'0.0014');%给每一个线段格式标注上
 xlabel('Number of iterations')
 ylabel('Cost function')
 prob = g([1, -0.2, -0.1]*theta);  %预测