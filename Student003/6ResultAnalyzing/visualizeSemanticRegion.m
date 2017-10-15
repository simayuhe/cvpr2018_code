close all;clear all;clc
n_th='5001';%************
iter=100;
rawdatafile=['../result/exper' n_th '/']
addpath (rawdatafile)
savpath=[rawdatafile 'classqq' num2str(iter) ];
file_name=['classqq' num2str(iter) '.txt'];
S=load(file_name);%classqq_word38.txt%change iter***********
load('D:\code\TEMP\Student003\FeatureExpression\testsavepath_5000\P_500.mat'); %P_100.mat
topics=S*P;%%change iter************
% read the topic distribution learned from Random Field Topic Model.
bg=imread('background.png');
bg=imresize(bg,[480 720]);

bg=im2double(bg);
for i=1:size(topics,1)
    curImg=genOptTopicIm_color(topics(i,:),bg);
    if~exist(savpath)
        mkdir(savpath)
    end
    imwrite(curImg,[savpath num2str(i) '.jpg'], 'jpg');% output the semantic regions
end

