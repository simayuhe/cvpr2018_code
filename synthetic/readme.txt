20170928
合成数据集的任务是验证算法的正确性：
用两层的DDCRF结构学习文档中的主题。

要求：产生原始数据，训练，学习得到的主题可视化，并记录每次迭代的likelihood，绘图

步骤：
1.先将主题，文档的产生过程用MATLAB完成，可以产生不同大小，主题混合程度的文档，可视化。

2.对迭代算法从头梳理，找到不合理的地方，对比前后两个版本，并做出接口。

3.组合不同主题混合程度，不同文档大小，不同文档个数，在不同版本，不同参数下的实验结果。也可以设计不同的初始化方案，这对下一步实验有很大作用。   	  	

设计表格，开始试验：

20170828

数据存储
主题：data/topic
文档：data/docset1/readme.txt 每个数据集中都会有一个readme.txt 存储文档大小个数，主题混合程度
	data/docset1/doc1~n.txt 存储每篇文档
	data/docset1/topiclabel1~n.txt 每个单词的topic标签
结果：result/exper1/para.txt 本次实验参数包括 所用数据集 超参数设定 迭代次数
	result/exper1/classqq1~n.txt 聚类得到主题
	result/exper1/likelihood.txt 每次迭代的log likelihood
可视化：result/exper1/classqq1~n.jpg 可视化
留用：storage/ 复制较好的实验结果 包括其数据集docset 实验结果exper 防止实验过程中产生覆盖