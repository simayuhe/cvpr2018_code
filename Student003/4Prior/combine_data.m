%��ȡ���ݣ����ϲ�,������ֹ�㣬���ʣ����飬����һ����ʼ��Ϣ������
close all;clear all;clc;
load ('../FeatureExpression/testsavepath_5000/tjc_encoded.mat')
%load ('./testsavepath/source_sink.mat')
load('./testsavepath_block_5000/prior.mat')
trainss=tjc_encoded';
save ('D:\code\TEMP\Student003\data\data5000frames\test.mat','cand_links','log_priors','trainss')