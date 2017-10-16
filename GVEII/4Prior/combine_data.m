%读取数据，并合并,包括起止点，单词，先验，还有一个初始信息（？）
close all;clear all;clc;
load ('../3FeatureExpression/testsavepath_2400/tjc_encoded.mat')
%load ('./testsavepath/source_sink.mat')
load('./testsavepath_block_2400/prior.mat')
trainss=tjc_encoded';
save ('D:\code\TEMP\GVEII\data\data2400frames\test.mat','cand_links','log_priors','trainss')