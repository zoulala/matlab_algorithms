# 自适应提升算法（adaboost）
目前集成学习有bagging、boosting算法，随机森林（RandomForest）是一种bagging的方法； Adaboost、GBDT、XGBoost 都是一种boosting方法。

# 原理概述
ref:https://my.oschina.net/u/3851199/blog/1941725

参考：李航的《统计学习方法》 AdaBoost通过加大分类误差率小的弱分类器的权重，
使其在表决中起的作用较大，减小分类误差率大的弱分类器的权重，使其在表决中起较小的作用。
