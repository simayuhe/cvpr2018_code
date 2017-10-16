close all;clear all;clc
n_th='2401';%************
iter=66;
backgroundIM=imread('D:\code\TEMP\GVEII\data\data2400frames\background.jpeg');
imwrite(backgroundIM,'background.jpg');
rawdatafile=['../result/exper' n_th '/']
addpath (rawdatafile)
savpath=[rawdatafile 'classqq' num2str(iter) ];
file_name=['classqq' num2str(iter) '.txt'];
S=load(file_name);%classqq_word38.txt%change iter***********
load('D:\code\TEMP\GVEII\3FeatureExpression\testsavepath_2400\P_1000.mat'); %P_100.mat
topics=S*P;%%change iter************
% read the topic distribution learned from Random Field Topic Model.

bg=imread('background.jpg');
bg=imresize(bg,[round(size(bg,1)/10)*10 round(size(bg,2)/10)*10]);



bg=im2double(bg);
for i=1:size(topics,1)
    curImg=genOptTopicIm_color(topics(i,:),bg);
    if~exist(savpath)
        mkdir(savpath)
    end
    imwrite(curImg,[savpath num2str(i) '.jpg'], 'jpg');% output the semantic regions
end

