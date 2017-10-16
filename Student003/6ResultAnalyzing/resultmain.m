%�õ�������classqqi.txt ֮��Խ����п��ӻ�
%��˼·��
%1.classqqi �е�ÿһ�ж����ֵ��ϵ�һ���ֲ�������Ҫ������ֲ�����������ֱ�Ӵ������������Ƿ���Ч��
%2.���������õ��ֵ���Ƭ�ι켣�ľ��࣬����������ϣ��õ�����һ��������Ϣ��
%  ���Խ�Ƭ�ι켣����ͶӰ����Ӧ�ķ��������н�����ʾ��
close all;clear all;clc
n_th='101';%************
iter=900;
dict_size=300;

backgroundIM=imread('../data/data5000frames/background.jpg');
load('../3FeatureExpression/testsavepath_5000/inds_sub_tjcs.mat');
load('../3FeatureExpression/testsavepath_5000/tjc_encoded.mat');
load('../3FeatureExpression/testsavepath_5000/tjc_res.mat');
[H,W,~]=size(backgroundIM);
sizeOfCell=10;
H=round(H/sizeOfCell)*sizeOfCell;
W=round(W/sizeOfCell)*sizeOfCell;
dict_grid_size=H*W*4/(sizeOfCell*sizeOfCell);%����ֵ�ĳ���
%backgroundIM=imresize(backgroundIM,H,W);
imwrite(backgroundIM,'background.jpg');
rawdatafile=['../result/exper' n_th '/']
addpath (rawdatafile);
savpath=[rawdatafile 'classqq' num2str(iter) ];
file_name=['classqq' num2str(iter) '.txt'];
S=load(file_name);%classqq_word38.txt%change iter***********
%%
%�������ֵ�ת����ֱ�Ӱ���Ӧ�Ĺ켣�����
%ÿ�����ʶ�Ӧ�Ĺ켣
dict=cell(size(S,2),1);%ÿ�����ʶ�Ӧtjc_den�е�λ��Ҳ�Ƕ�Ӧinds_sub_tjc�е�λ��

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
%��������Ҫ��ÿ������ӳ�䵽һ���������Ȼ����ʾ����
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
% dict_grid_size=H*W*4/(sizeOfCell*sizeOfCell);%����ֵ�ĳ���
% %backgroundIM=imresize(backgroundIM,H,W);
% classqq_t=zeros(1,dict_grid_size);
% words = encode_tjc(x,H,W,sizeOfCell);%�ܵõ�ĳһ��Ƭ�ι켣�ڷ��������ӳ��
% for i=1:1:length(words)
%     classqq_t(1,words(i))=classqq_t(1,words(i))+1;
% end
% curImg=genOptTopicIm_color(classqq_t,backgroundIM);
% imshow(curImg);
% hold off
%%
%��ÿ�����൥�ʶ�Ӧ����񻮷ֵĵ�����ȥ,��һ�������ʾ�����൥��1000������񻮷���ͼƬ��С����36864
if exist(['./P' num2str(dict_size) '.mat'])
	load(['./P' num2str(dict_size) '.mat']);
else
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
            sub_tjc=tjc_res{1,idx_tjc}(idx_point,:);%һ��Ƭ�ι켣�����
            %plot(sub_tjc(:,1),sub_tjc(:,2),'b*');
            words_grid=encode_tjc(sub_tjc,H,W,sizeOfCell);
            for jj=1:1:length(words_grid)
                %ͳ��ÿ���ӹ켣�ж�Ӧdict_grid�еĴ�Ƶ
                P(word_i,words_grid(jj))=P(word_i,words_grid(jj))+1;
            end
        end
        %ÿ����һ������Ҫ����һ�ι�һ��
        if sum( P(word_i,:))>0
            P(word_i,:)=P(word_i,:)./sum( P(word_i,:));
        end
    end
    save(['./P' num2str(dict_size) '.mat'],'P');
end
%%
%��һ��������ʾ����
topics=S*P;
for i=1:size(topics,1)
    curImg=genOptTopicIm_color(topics(i,:),backgroundIM);
    if~exist(savpath)
        mkdir(savpath)
    end
    imwrite(curImg,[savpath num2str(i) '.jpg'], 'jpg');% output the semantic regions
end
