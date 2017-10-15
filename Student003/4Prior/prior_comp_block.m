close all;clear all;clc;
%根据不同的衰减函数计算先验概率
temp_dir='./testsavepath_block_5000/';
load ([temp_dir 'len.mat']);
cand_links = cell(full_size,1);
log_priors = cell(full_size,1);
for s=1:1:len
    for e=1:1:len
        load ([temp_dir 'D' num2str(s) '_' num2str(e) '.mat']);
        F=myfunction(D,'exp');%计算衰减函数 ，'exp'，'logistic'
        [row, col ,v]=find(F~=0);
        for i=1:1:length(row)
            cand_links{row(i)+per*(s-1)}=[cand_links{row(i)+per*(s-1)} col(i)+per*(e-1)];
            log_priors{row(i)+per*(s-1)}=[log_priors{row(i)+per*(s-1)} log(F(row(i),col(i)))];
        end
    end
end
save([temp_dir 'prior.mat'],'cand_links','log_priors')
%save([ 'prior.mat'],'cand_links','log_priors')
