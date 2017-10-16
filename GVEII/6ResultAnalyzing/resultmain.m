%得到聚类结果classqqi.txt 之后对结果进行可视化
%基本思路：
%1.classqqi 中的每一行都是字典上的一个分布，我们要把这个分布画出来；（直接打出来看看结果是否有效）
%2.由于我们用的字典是片段轨迹的聚类，而我们最终希望得到的是一个区域信息，
%  所以将片段轨迹的类投影到相应的方格区域中进行显示。
close all;clear all;clc
n_th='2401';%************
iter=66;
dict_size=1000;

backgroundIM=imread('D:\code\TEMP\GVEII\data\data2400frames\background.jpeg');
[H,W,~]=size(backgroundIM);
sizeOfCell=10;
H=round(H/sizeOfCell)*sizeOfCell;
W=round(W/sizeOfCell)*sizeOfCell;
dict_grid_size=H*W*4/(sizeOfCell*sizeOfCell);%网格字典的长度
%backgroundIM=imresize(backgroundIM,H,W);
imwrite(backgroundIM,'background.jpg');
rawdatafile=['../result/exper' n_th '/']
addpath (rawdatafile);
savpath=[rawdatafile 'classqq' num2str(iter) ];
file_name=['classqq' num2str(iter) '.txt'];
S=load(file_name);%classqq_word38.txt%change iter***********
%%
%不进行字典转换，直接把相应的轨迹打出来
%每个单词对应的轨迹
dict=cell(size(S,2),1);%每个单词对应tjc_den中的位置也是对应inds_sub_tjc中的位置
load('../3FeatureExpression/testsavepath_2400/inds_sub_tjcs.mat');
load('../3FeatureExpression/testsavepath_2400/tjc_encoded.mat');
load('../3FeatureExpression/testsavepath_2400/tjc_res.mat');
for idx_doc=1:1:size(tjc_encoded,2)
    for idx_word=1:1:length(tjc_encoded{1,idx_doc})
        word=tjc_encoded{1,idx_doc}(idx_word);
        if size(dict{word,1})==0
            dict{word,1}=[idx_doc idx_word];
        else
            dict{word,1}=[dict{word,1};idx_doc idx_word];
        end
    end   
end
% imshow(backgroundIM);
% hold on;
% idx_classi=find(S(4,:)>0)
% for idx_dict=idx_classi
%     %idx_dict=1;
%     for dict_i=1:1:size(dict{idx_dict,1},1)
%         idx_tjc=dict{idx_dict,1}(dict_i,1);
%         idx_sub=dict{idx_dict,1}(dict_i,2);%
%         idx_point=inds_sub_tjcs{idx_tjc,1}{1,idx_sub}(1,:);
%         sub_tjc=tjc_res{1,idx_tjc}(idx_point,:);
%         plot(sub_tjc(:,1),sub_tjc(:,2),'b*');
%     end
% end
% hold off;

%%
%现在是需要把每个单词映射到一个区域块中然后显示出来
% figure(2)
% imshow(backgroundIM)
% hold on
% x=sub_tjc;
% 
% [H,W,~]=size(backgroundIM);
% sizeOfCell=10;
% H=round(H/sizeOfCell)*sizeOfCell
% W=round(W/sizeOfCell)*sizeOfCell
% 
% dict_grid_size=H*W*4/(sizeOfCell*sizeOfCell);%网格字典的长度
% %backgroundIM=imresize(backgroundIM,H,W);
% classqq_t=zeros(1,dict_grid_size);
% words = encode_tjc(x,H,W,sizeOfCell);%能得到某一条片段轨迹在方格区域的映射
% for i=1:1:length(words)
%     classqq_t(1,words(i))=classqq_t(1,words(i))+1;
% end
% curImg=genOptTopicIm_color(classqq_t,backgroundIM);
% imshow(curImg);
% hold off
%%
%把每个聚类单词对应到网格划分的单词中去,用一个矩阵表示，聚类单词1000个，网格划分由图片大小决定36864
P=zeros(dict_size,dict_grid_size);
for word_i=1:1:dict_size
    idx_dict=word_i;
    if size(dict{idx_dict,1},1)==0
        display('There are some empty clusters in this dictionary set');
    end
    for dict_i=1:1:size(dict{idx_dict,1},1)
        idx_tjc=dict{idx_dict,1}(dict_i,1);
        idx_sub=dict{idx_dict,1}(dict_i,2);%
        idx_point=inds_sub_tjcs{idx_tjc,1}{1,idx_sub}(1,:);
        sub_tjc=tjc_res{1,idx_tjc}(idx_point,:);%一个片段轨迹的坐标
        %plot(sub_tjc(:,1),sub_tjc(:,2),'b*');
        words_grid=encode_tjc(sub_tjc,H,W,sizeOfCell);
        for jj=1:1:length(words_grid)
            %统计每个子轨迹中对应dict_grid中的词频
            P(word_i,words_grid(jj))=P(word_i,words_grid(jj))+1;
        end
    end
    %每做完一个单词要进行一次归一化
    if sum( P(word_i,:))>0
        P(word_i,:)=P(word_i,:)./sum( P(word_i,:));
    end
end
%%
%把一个主题显示出来
topics=S*P;
for i=1:size(topics,1)
    curImg=genOptTopicIm_color(topics(i,:),backgroundIM);
    if~exist(savpath)
        mkdir(savpath)
    end
    imwrite(curImg,[savpath num2str(i) '.jpg'], 'jpg');% output the semantic regions
end
