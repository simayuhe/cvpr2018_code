function [ output_args ] = plot_dictionary( res_sub_tjc,trainss,res_dir )
%PLOT_DICTIONARY �˴���ʾ�йش˺����ժҪ
%   �����ز���֮����ӹ켣����Ӧ��������ͼ��

%res_dir = './temp_data/';
T = size(res_sub_tjc,2)/2;
n = size(res_sub_tjc,1);
res_sub_tjc = reshape(res_sub_tjc', T, 2*n);
res_sub_tjc = mat2cell(res_sub_tjc, T, 2*ones(1,n));
trainss = cell2mat(trainss);
K = 1000;
num_vis = n;
inds_vis = randperm(n, num_vis);
res_sub_tjc = res_sub_tjc(inds_vis);
trainss = trainss(inds_vis);
trainss = trainss.';
I = imread('./background.jpg');
scale = [0 size(I,2) 0 size(I,1)];
hold on
%parpool(4)
for cc = 1:K
%     cc = cls_vis(ii);
    if cc == 1
        plot_tjcs3(res_sub_tjc, find(trainss==cc), scale, I, rand(1,3));
    else
        plot_tjcs4(res_sub_tjc, find(trainss==cc), rand(1,3));
    end
end
saveas(gcf, [res_dir 'tracklet_code_book.fig']);        % save to .fig files
print(gcf, '-depsc', [res_dir 'tracklet_code_book']);    % print to .eps files
saveas(gcf, [res_dir 'tracklet_code_book.jpg']);

end

