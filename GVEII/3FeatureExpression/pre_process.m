%目标：单词的码本的构建  
%输入：原始数据
%输出：字典，及轨迹的单词表示
%处理全数据集，单词码本长度1000
%%
%读入原始数据去掉ss信息，保留轨迹的坐标和时间
close all ;clear all;clc;
%%%%%%%%%%%%%
%需要更改数据源，并更改聚类中心个数，即字典的大小
originalfilename= 'D:\code\TEMP\GVEII\data\data2400frames\Trks.mat';
backgroundIM=imread('D:\code\TEMP\GVEII\data\data2400frames\background.jpeg');
imwrite(backgroundIM,'background.jpg');
%%%%%%%%%%%%%%%%%%%%%
load(originalfilename)
trks=Trks;
%%
temp_dir='./testsavepath_2400/';
if ~exist(temp_dir)
    mkdir(temp_dir)
end

n=length(trks);
for i=1:1:n
    %tjc_xyt{i}=[trks(i).x trks(i).y trks(i).t];
    time_vector(i)=trks(i).t(1);
end
%save 'n.mat' n
%save ([temp_dir 'tjc_xyt.mat'], 'tjc_xyt');
save ([temp_dir 'time_vector.mat'],'time_vector');%'./temp_data/time_vector.mat' time_vector
% load ([temp_dir 'tjc_xyt.mat']);
% for i=1:1:n
%     tjc_xy{i}=tjc_xyt{i}(:,1:2);
% end
% save([temp_dir 'tjc_xy.mat'],'tjc_xy');% './temp_data/tjc_xy.mat' tjc_xy
%按时间排序
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load ([temp_dir 'time_vector.mat']);%'./temp_data/time_vector.mat'
[time_vec_new index_new]=sort(time_vector);
%load './original/matlab_tracklets.mat';
n=length(trks);

for i=1:1:n
    trks_time_based(i)=trks(index_new(i));
end
j=1;
%source_sink=[];
for i=1:1:n
%     if i==40528
%         continue;
%     end
    tjc_xyt{j}=[trks_time_based(i).x trks_time_based(i).y trks_time_based(i).t];
    tjc_xy{j}=tjc_xyt{j}(:,1:2);
    %source_sink=[source_sink;trks_time_based(i).ss'];
    j=j+1;
end
%save([temp_dir 'source_sink.mat'],'source_sink');
 save([temp_dir 'tjc_xy.mat'],'tjc_xy');
save ([temp_dir 'tjc_xyt.mat'], 'tjc_xyt');
save([temp_dir 'index_new.mat'],'index_new');% './temp_data/index_new.mat' index_new
save([temp_dir 'trks_time_based.mat'],'trks_time_based');%'./temp_data/trks_time_based.mat' trks_time_based
%%
%对每条轨迹进行降噪处理,这里遇到一个小波降噪用的是现成的函数，具体细节需要学习
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load ([temp_dir 'tjc_xy.mat']);%'./temp_data/tjc_xy.mat'
do_plot=0;
[ tjc_den ] = denoise_of_tjcxy( tjc_xy,do_plot);
save([temp_dir 'tjc_den.mat'],'tjc_den');% './temp_data/tjc_den.mat' tjc_den
%%
%对降噪之后的轨迹重新采样
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'tjc_den.mat']);% './temp_data/tjc_den.mat'
%[ tjc_res ,len_tjc ] = tjc_resample( tjc_den,do_det_odd,do_plot,ds )
[ tjc_res ,len_tjc ] = tjc_resample( tjc_den,1,0,1 ) ;  
save([temp_dir 'tjc_res.mat'],'tjc_res');% './temp_data/tjc_res.mat' tjc_res len_tjc
%%
%每条轨迹分成若干小段
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'tjc_res.mat']);% './temp_data/tjc_res.mat' 
ave_num_seg=8;
do_plot=0;
[ inds_sub_tjcs , num_sub_tjc ] = tjc_divide( tjc_res, len_tjc,ave_num_seg,do_plot);
save([temp_dir 'inds_sub_tjcs.mat'],'inds_sub_tjcs');% './temp_data/inds_sub_tjcs.mat' inds_sub_tjcs
save([temp_dir 'num_sub_tjc.mat'],'num_sub_tjc');%'./temp_data/num_sub_tjc.mat' num_sub_tjc
%%
%对小段进行重采样
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'inds_sub_tjcs.mat']);%'./temp_data/inds_sub_tjcs.mat'
load([temp_dir 'num_sub_tjc.mat']);% './temp_data/num_sub_tjc.mat'
load ([temp_dir 'tjc_res.mat']);%./temp_data/tjc_res.mat' 
[sub_tjc_resampled] = sub_tjc_res( inds_sub_tjcs,tjc_res );
save([temp_dir 'sub_tjc_resampled.mat'],'sub_tjc_resampled');%'./temp_data/sub_tjc_resampled.mat' sub_tjc_resampled

%%
%产生用于聚类的特征
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'sub_tjc_resampled.mat']);% './temp_data/sub_tjc_resampled.mat'
n_dim=4;
[ sub_tjc_features ] = generate_feature( sub_tjc_resampled,n_dim );
save([temp_dir 'sub_tjc_features.mat'],'sub_tjc_features');% './temp_data/sub_tjc_features.mat' sub_tjc_features
%%
%使用kmeans 聚类得到词典
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'sub_tjc_features.mat']);% './temp_data/sub_tjc_features.mat'
k=500;%%%词典长度,聚类 个数
[IDX,C] = kmeans(sub_tjc_features,k,'start','uniform','MaxIter',2000);
save([temp_dir 'IDX.mat'],'IDX');%'./temp_data/IDX.mat' IDX
save([temp_dir 'C.mat'],'C');% './temp_data/C.mat' C
%%
%并将轨迹表示为单词
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'IDX.mat']);% './temp_data/IDX.mat'
load([temp_dir 'num_sub_tjc.mat']);% './temp_data/num_sub_tjc.mat'
cnt=0;
for ii=1:length(num_sub_tjc)
    k_temp=num_sub_tjc(ii)
    for jj=1:1:k_temp
        tjc_encoded{ii}(jj)=IDX(cnt+jj);  
    end
    cnt=cnt+k_temp;
    clear k_temp;
end
save([temp_dir 'tjc_encoded.mat'],'tjc_encoded');%'./temp_data/tjc_encoded.mat' tjc_encoded
%%
%把词典绘制在图中
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'sub_tjc_resampled.mat']);% './temp_data/sub_tjc_resampled.mat'
load([temp_dir 'tjc_encoded.mat']);% './temp_data/tjc_encoded.mat'
plot_dictionary( sub_tjc_resampled,tjc_encoded ,temp_dir);
%%
%每条子轨迹用RFT中的视觉单词表示，得到vis_word方便用来可视化
%使用的是tjc_res
K=1000;
convert_to_vis_words(temp_dir);%得到vis_words
vhddcrp2vrft(temp_dir,K);%得到P_1000，使用这个矩阵能把聚类的结果classqq直接转换为可视化的图片
display('here')