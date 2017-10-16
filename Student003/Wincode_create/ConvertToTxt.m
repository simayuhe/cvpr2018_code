close all;clear all;clc 
datapath='~/cvpr2018_code/Student003/data/data5000frames/';
dataname='test.mat';
load([datapath dataname]);

for i=1:1:length(trainss)
    doc_name = [datapath 'doc_' num2str(i) '.txt'];
    fid=fopen(doc_name,'wt');  
    for j=1:1:size(trainss{i},2)
        word=trainss{i}(1,j);
         fprintf(fid,'%g\t',word);
         clear word;
    end
    fclose(fid);
     
    cand_link_name = [datapath 'cand_link' num2str(i) '.txt'];
    log_prior_name =[datapath 'log_prior' num2str(i) '.txt'];
    fid1=fopen(cand_link_name,'wt');
    fid2=fopen(log_prior_name,'wt');
    fprintf(fid1,'[%g]\t',length(cand_links{i}));
    fprintf(fid2,'[%g]\t',length(log_priors{i}));
    for j=1:1:length(cand_links{i})
         fprintf(fid1,'%g\t',cand_links{i}(j));
        fprintf(fid2,'%g\t',log_priors{i}(j));
    end
    fclose(fid1);
     fclose(fid2);
%      
%      ss_name=[datapath 'ss_' num2str(i) '.txt'];
%      fid3=fopen(ss_name,'wt');
%      fprintf(fid3,'%g\t',source_sink(i,1));
%      fprintf(fid3,'%g\t',source_sink(i,2));
%      fclose(fid3);
%      
%      init_ss_name= [datapath 'init_ss_' num2str(i) '.txt'];
%      fid4=fopen(init_ss_name,'wt');
%      fprintf(fid4,'%g\t',init_ss(i,1));
%      fprintf(fid4,'%g\t',init_ss (i,2));
%      fclose(fid4);
     
end
