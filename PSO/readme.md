# 粒子群优化(PSO)
一种参数优化算法：通过模拟鸟群觅食过程中的迁徙和群聚行为而提出的一种基于群体智能的全局随机搜索算法

# 步骤：
    Step1:初始化粒子群，包括群体规模clip_image004[1]，每个粒子的位置clip_image048和速度clip_image050

    Step2:计算每个粒子的适应度值clip_image052；

    Step3: 对每个粒子，用它的适应度值clip_image052[1]和个体极值clip_image054比较，如果clip_image056 ，则用clip_image058替换掉clip_image054[1]；

    Step4: 对每个粒子，用它的适应度值clip_image058[1]和全局极值clip_image061比较，如果clip_image056[1]则用clip_image052[2]替clip_image061[1]；

    Step5: 根据公式（2-1），（2-2）更新粒子的速度clip_image050[1]和位置clip_image048[1] ；

    Step6: 如果满足结束条件(误差足够好或到达最大循环次数)退出，否则返回Step2。



