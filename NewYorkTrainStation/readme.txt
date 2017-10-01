20170928

这里要包含整个框架的处理过程，及其可视化方案

1.原始数据集的可视化分析，（source-sink）,以及数据集按时间段的拆分

2.轨迹片段的编码过程，参数选取：平均分段多少与字典长度的关系

3.各个层级的先验制作与统一表示：第一层序列先验，第二层pairwise先验，第三层不适用先验，或使用树结构作为先验

4.三层模型结构的设计，以及结构组件的便捷植入，比如调参，先验源的切换，初始化的切换，不同初始化，

5.各种参数下的实验对比

6.与谱聚类，k-means 等方法的对比

20171001
不同数据集：data/origin/doc1~n.txt
		data/origin/link1~n.txt
		data/half/doc1~n.txt
		data/half/link1~n.txt
		data/minidata/doc1~n.txt
		data/minidata/link1~n.txt
实验结果：result/exper1/para.txt
	result/exper1/classqq.txt
	result/exper1/likelihood.txt

两个版本的推断代码进行对比：tian_code
				xin_code

先把田国栋师兄的代码重新跑通，移植到到Linux中
再把改过后的代码跑通，移植到Linux中
之后寻求各种先验的改变规律


20171001
要把两个代码对比跑
现在的输入没有完全改到txt格式，不能应用到Linux上去
改到Linux上之后先用同样的minidata比较一下二者的速度
还有可视化的结果


