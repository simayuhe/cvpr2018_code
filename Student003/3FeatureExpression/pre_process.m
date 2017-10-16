%Ŀ�꣺���ʵ��뱾�Ĺ���  
%���룺ԭʼ���
%������ֵ䣬���켣�ĵ��ʱ�ʾ
%����ȫ��ݼ��������뱾����1000
%%
%����ԭʼ���ȥ��ss��Ϣ�������켣������ʱ��
close all ;clear all;clc;
%%%%%%%%%%%%%
%��Ҫ������Դ������ľ������ĸ����ֵ�Ĵ�С
originalfilename= '~/cvpr2018_code/Student003/data/data5000frames/Trks.mat';
backgroundIM=imread('~/cvpr2018_code/Student003/data/data5000frames/background.jpg');
imwrite(backgroundIM,'background.jpg');
%%%%%%%%%%%%%%%%%%%%%
load(originalfilename)
trks=Trks;
%%
temp_dir='./testsavepath_5000/';
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
%��ʱ������
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
%��ÿ���켣���н��봦��,��������һ��С�������õ����ֳɵĺ������ϸ����Ҫѧϰ
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load ([temp_dir 'tjc_xy.mat']);%'./temp_data/tjc_xy.mat'
do_plot=0;
[ tjc_den ] = denoise_of_tjcxy( tjc_xy,do_plot);
save([temp_dir 'tjc_den.mat'],'tjc_den');% './temp_data/tjc_den.mat' tjc_den
%%
%�Խ���֮��Ĺ켣���²���
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'tjc_den.mat']);% './temp_data/tjc_den.mat'
%[ tjc_res ,len_tjc ] = tjc_resample( tjc_den,do_det_odd,do_plot,ds )
[ tjc_res ,len_tjc ] = tjc_resample( tjc_den,1,0,1 ) ;  
save([temp_dir 'tjc_res.mat'],'tjc_res');% './temp_data/tjc_res.mat' tjc_res len_tjc
%%
%ÿ���켣�ֳ�����С��
% close all ;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'tjc_res.mat']);% './temp_data/tjc_res.mat' 
ave_num_seg=8;
do_plot=0;
[ inds_sub_tjcs , num_sub_tjc ] = tjc_divide( tjc_res, len_tjc,ave_num_seg,do_plot);
save([temp_dir 'inds_sub_tjcs.mat'],'inds_sub_tjcs');% './temp_data/inds_sub_tjcs.mat' inds_sub_tjcs
save([temp_dir 'num_sub_tjc.mat'],'num_sub_tjc');%'./temp_data/num_sub_tjc.mat' num_sub_tjc
%%
%��С�ν����ز���
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'inds_sub_tjcs.mat']);%'./temp_data/inds_sub_tjcs.mat'
load([temp_dir 'num_sub_tjc.mat']);% './temp_data/num_sub_tjc.mat'
load ([temp_dir 'tjc_res.mat']);%./temp_data/tjc_res.mat' 
[sub_tjc_resampled] = sub_tjc_res( inds_sub_tjcs,tjc_res );
save([temp_dir 'sub_tjc_resampled.mat'],'sub_tjc_resampled');%'./temp_data/sub_tjc_resampled.mat' sub_tjc_resampled

%%
%�������ھ��������
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'sub_tjc_resampled.mat']);% './temp_data/sub_tjc_resampled.mat'
n_dim=4;
[ sub_tjc_features ] = generate_feature( sub_tjc_resampled,n_dim );
save([temp_dir 'sub_tjc_features.mat'],'sub_tjc_features');% './temp_data/sub_tjc_features.mat' sub_tjc_features
%%
%ʹ��kmeans ����õ��ʵ�
% close all;clear all;clc
% temp_dir='./testsavepath/';
load([temp_dir 'sub_tjc_features.mat']);% './temp_data/sub_tjc_features.mat'
k=300;%%%�ʵ䳤��,���� ����
[IDX,C] = kmeans(sub_tjc_features,k,'start','uniform','MaxIter',2000);
save([temp_dir 'IDX.mat'],'IDX');%'./temp_data/IDX.mat' IDX
save([temp_dir 'C.mat'],'C');% './temp_data/C.mat' C
%%
%�����켣��ʾΪ����
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
%�Ѵʵ������ͼ��
% close all;clear all;clc
% %temp_dir='./testsavepath/';
% temp_dir='./testsavepath_5000/';
load([temp_dir 'sub_tjc_resampled.mat']);% './temp_data/sub_tjc_resampled.mat'
load([temp_dir 'tjc_encoded.mat']);% './temp_data/tjc_encoded.mat'
plot_dictionary( sub_tjc_resampled,tjc_encoded ,temp_dir);
%%
%ÿ���ӹ켣��RFT�е��Ӿ����ʱ�ʾ���õ�vis_word�����������ӻ�
%ʹ�õ���tjc_res
K=300;
convert_to_vis_words(temp_dir);%�õ�vis_words
vhddcrp2vrft(temp_dir,K);%�õ�P_1000��ʹ����������ܰѾ���Ľ��classqqֱ��ת��Ϊ���ӻ���ͼƬ
