%��ȡ���ݣ����ϲ�,������ֹ�㣬���ʣ����飬����һ����ʼ��Ϣ������
close all;clear all;clc;
load ('../3FeatureExpression/testsavepath_2400/tjc_encoded.mat')
%load ('./testsavepath/source_sink.mat')
load('./testsavepath_block_2400/prior.mat')
trainss=tjc_encoded';
save ('D:\code\TEMP\GVEII\data\data2400frames\test.mat','cand_links','log_priors','trainss')