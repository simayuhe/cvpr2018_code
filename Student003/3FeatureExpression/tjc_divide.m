function [ inds_sub_tjcs , num_sub_tjc ] = tjc_divide( tjc_pro, len_tjc,ave_num_seg,do_plot)
%TJC_DIVIDE 此处显示有关此函数的摘要
%   此处显示详细说明
num_tjc = length(tjc_pro);
ave_len_seg = sum(len_tjc) / (ave_num_seg*num_tjc);
inds_sub_tjcs = cell(length(tjc_pro),1);
if do_plot
    h1 = figure;
end
%parpool(4)
for ii = 1:length(tjc_pro)
    fprintf(1, 'divide tjc %d\n', ii);
    k = ceil(len_tjc(ii)/ave_len_seg);
    X = tjc_pro{ii};
    if k > 1
        X = [X 50*(1:size(X,1))'];
        D = sqrt(dist2(X,X));              %% Euclidean distance
        neighbor_num = 15;
        [u0,A_LS,u1] = scale_dist(D,floor(neighbor_num/2)); %% Locally scaled affinity matrix
        ZERO_DIAG = ~eye(size(X,1));
        A_LS = A_LS.*ZERO_DIAG;
        [clusts, ~] = gcut(A_LS,k);
	    seg_labels = zeros(1, size(X,1));
		for jj = 1:length(clusts)
            seg_labels(clusts{jj}) = jj;
        end
        gaps = zeros(1,100);
        cnt = 1;
        gaps(1) = 1;
        idx_cur = seg_labels(1);
        for jj = 2:length(seg_labels)
            if seg_labels(jj) ~= idx_cur
                idx_cur = seg_labels(jj);
                cnt = cnt + 1;
                gaps(cnt) = jj;
            end
        end
        k = cnt;
        gaps(cnt+1) = length(seg_labels);
        inds_sub_tjcs{ii} = cell(1,k);
        inds_sub_tjcs{ii}{1} = gaps(1):gaps(2);
        for kk = 2:k
            inds_sub_tjcs{ii}{kk} = gaps(kk)-1:gaps(kk+1);
        end
    else
        inds_sub_tjcs{ii} = cell(1,1);
        inds_sub_tjcs{ii}{1} = 1:size(X,1);
    end
    if do_plot
        plot_divided_tjc(tjc_pro{ii},inds_sub_tjcs{ii},h1);
        input('Press enter to continue:');
        figure(h1);
    end
end
num_sub_tjc = zeros(length(inds_sub_tjcs),1);
for ii = 1:length(inds_sub_tjcs)
    num_sub_tjc(ii) = length(inds_sub_tjcs{ii});
end

end

