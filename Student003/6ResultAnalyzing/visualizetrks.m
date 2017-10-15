%显示聚类之后的轨迹
%绘制全轨迹
%1120
close all;clear all;clc;
tempdir='./result_1120/';
addpath (tempdir)
load('D:\code\mycode\HDDCRP_V1\data_small\preprocessing\testsavepath\tjc_xy.mat');
num=5;
tjcs=tjc_xy;
filename={['classqq_sink',num2str(num),'.txt'];
    ['classqq_source',num2str(num),'.txt'];
    ['classqq_word',num2str(num),'.txt'];
    ['label',num2str(num),'.txt'];
    ['topic_label',num2str(num),'.txt']};

classqq_sink=load(filename{1});
classqq_source=load(filename{2});% classqq_source700.txt
classqq_word=load(filename{3});% classqq_word700.txt
label=load(filename{4});% label700.txt
topic_label=load(filename{5});% topic_label700.txt
tab_label=tabulate(label);
T=size(tab_label,1);
color_sink=classqq_sink*[1 2 3 4 5 6 7 8]'./(36.*sum(classqq_sink,2));
color_source=classqq_source*[1 2 3 4 5 6 7 8]'./(36.*sum(classqq_source,2));
color_word=classqq_word*(1:100)'./(5050.*sum(classqq_word,2));
color_mat=[color_sink.*(1/max(color_sink)) color_source.*(1/max(color_source)) color_word.*(1/max(color_word))];
I=imread ('background.jpg');
%I=ones(size(I));

length_of_tjcs =size(tjcs,1);
for k=1:T
    figure (1)
    imshow (I);
    hold on;
    for ii=(find(label==tab_label(k,1)))'
        ii;%ii=1:length_of_tjcs
        tjcs_ii=tjcs{ii};
        %length_of_ii=size(tjcs_ii,1);
         color_ii=color_mat(k,:);%color_mat(find(tab_label(:,1)==label120(ii)),:);
         plot(tjcs_ii(:,1),tjcs_ii(:,2),'Color',color_ii);
    end
    name=['figure',num2str(num),'_',num2str(k),'.jpg'];
    filename=[tempdir 'pic/'];
    if ~exist(filename)
        mkdir(filename)
    end
   saveas(gcf,[filename name],'jpg');
  hold off;
end
