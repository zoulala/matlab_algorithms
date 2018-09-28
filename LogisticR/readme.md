# 逻辑斯蒂回归(LR)
为二分类模型（0~1）： 实际上是一个sigmoid函数
>y_pre=1/1+e^(b0+b1*x1+b2*x2+……+bp*xp)

# 目标函数（由极大释然估计得出）
> 最小化 J =(1/sample_num).*sum(-y.*log(y_pre) - (1-y).*log(1-y_pre))


ref：https://blog.csdn.net/zjuPeco/article/details/77165974
