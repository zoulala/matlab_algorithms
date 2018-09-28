function [ w,x_mean,x_std ] = LR_model( x,y,alpha,echo,figure_flag )
%逻辑回归
%参考：http://blog.csdn.net/hechenghai/article/details/46817031
%x=[m*n]的矩阵，y=[m*1]的0/1向量。 
%alpha为梯度下降学习速率, itera_num为梯度下降迭代次数


 [m, n] = size(x);
 sample_num = m;
x_mean=mean(x);x_std=std(x);
x=zscore(x);
x = [ones(m, 1), x]; %x增加一维。因为前面文字或前几节说了

% pos = find(y == 1); neg = find(y == 0);%pos 和neg 分别是 y元素=1和0的所在的位置序号组成的向量

 g = inline('1.0 ./ (1.0 + exp(-z))','z'); %这个就相当于制造了一个function g（z）=1.0 ./ (1.0 + exp(-z))

theta = zeros(n+1, 1);%thera表示样本Xi各个元素叠加的权重系数，这里以向量形式表示，且初始都为0，三维向量
J = zeros(echo, 1);%itera_num*1的向量，第n个元素代表第n次迭代cost function的值（下面用negtive 的对数似然函数，
%因为是negtive 的，所以是求得极小值）
for i = 1:echo %计算出某个学习速率alpha下迭代itera_num次数后的参数   
 z = x * theta;%这个z是一个列向量，每一个元素是每一个样本Xi的线性叠加和，因为X是所有的样本，因此这里不是一个一个样本算的，
 %而是所有样本一块算的，因此z是一个包含所有样本Xi的线性叠加和的向量。在公式中，是单个样本表示法，而在matlab中都是所有的样本一块来。
 h = g(z);%这个h就是样本Xi所对应的yi=1时，映射的概率。如果一个样本Xi所对应的yi=0时，对应的映射概率写成1-h。
 J(i) =(1/sample_num).*sum(-y.*log(h) - (1-y).*log(1-h));%损失函数的矢量表示法 这里Jtheta是个100*1的列向量。
 grad = (1/sample_num).*x'*(h-y);%这个是向量形式的，我们看到grad在公式中是gradj=1/m*Σ（Y（Xi）-yi）Xij ，写得比较粗略，
 %这里（Y（Xi）-yi）、Xij %都是标量，而在程序中是以向量的形式运算的，所以不能直接把公式照搬，所以要认真看看，代码中相应改变一下。
 theta = theta - alpha*grad;
end

    if figure_flag==1
    plot(0:echo-1, J(1:echo),'b-','LineWidth', 2)

    %此处一定要通过char函数来转换因为包用（）索引后得到的还是包cell，
    %所以才要用char函数转换，也可以用{}索引，这样就不用转换了。
    %一个学习速率对应的图像画出来以后再画出下一个学习速率对应的图像。    

    xlabel('Number of iterations')
    ylabel('Cost function')
    title('最小化损失误差迭代过程');
    end
w=theta ;
%prob = g([1, -0.2, -0.1]*theta);  %预测
end

