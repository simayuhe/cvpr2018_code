function vhddcrp2vrft( res_dir,K)
%VHDDCRP2VRFT 此处显示有关此函数的摘要
%   此处显示详细说明,合并从聚类所用单词到轨迹片段的变换矩阵与从轨迹片段到视觉单词的变换矩阵
%  K表示聚类单词词典长度
load ([res_dir 'tjc_encoded'])
%load trainss_100_500.mat
doc_on_V1=[];%ddcrf中的文档，单词数目是K
for i=1:1:length(tjc_encoded)  
        doc_on_V1=[doc_on_V1;tjc_encoded{i}'];  
end
load([res_dir 'vis_words.mat'])
% doc_on_V2=[];%rft中的文档，单词数目是48*72*4=13824
P=zeros(K,13824);
for ii=1:1:K%对每一个V1中的单词
    ind{ii}=find(doc_on_V1==ii);%找出这些单词在文档中对应的位置
    for jj=1:1:length(ind{ii})
        ind_jj=ind{ii}(jj);
        sent_in_V2=vis_words{ind_jj};%文档中的一行
        for pp=1:1:length(sent_in_V2)
            value=sent_in_V2(pp);%一行中单词（V2词典下的）
            P(ii,value)=P(ii,value)+1;
        end
    end
end
save ([res_dir 'P_' num2str(K) '.mat'],'P')

end

