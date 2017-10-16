Yongxin Kang
20161116
用来处理小数据集：
对数据的预处理过程，在pre_process.m 完成，包括:
1.时间排序；
2.滤波；denoise_of_tjcxy
 2.1 resample
3.分割；
4.PCA；
5.K-means聚类；

20170111
处理全数据集
可调参数：
ave_num_seg=8;平均分段个数
n_dim=4;用于聚类的特征数
词典长度

总会有数据点无法通过滤波处理很是头疼


