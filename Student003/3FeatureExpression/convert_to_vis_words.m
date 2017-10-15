function convert_to_vis_words(res_dir)%, trk_doc_file)
% res_dir = './dataset/train_station/';
do_trans = 1;
if do_trans
    load([res_dir 'tjc_res.mat'], 'tjc_res');
    load([res_dir 'inds_sub_tjcs.mat'], 'inds_sub_tjcs');
    load([res_dir 'num_sub_tjc.mat'], 'num_sub_tjc');
    N = sum(num_sub_tjc);
    vis_words = cell(N,1);
    cnt = 0;
    for ii = 1:length(inds_sub_tjcs)
        tjc_ii = tjc_res{ii};
        for jj = 1:length(inds_sub_tjcs{ii})
            cnt = cnt + 1;
            vis_words{cnt} = encode_tjc(tjc_ii(inds_sub_tjcs{ii}{jj},:));
        end
    end
    save([res_dir 'vis_words.mat'], 'vis_words');
else
    load([res_dir 'vis_words.mat'], 'vis_words');
end

% % V = 72*48*4;
% % inds_i = cell2mat(vis_words');
% % cnt = 0;
% % for nn = 1:N
% %     w_nn = vis_words{nn};
% %     len = length(w_nn);
% %     inds_i(cnt+1:cnt+len) = nn;
% %     cnt = cnt + len;
% % end
% % inds_j = cell2mat(vis_words');
% % topic_table = sparse(inds_i, inds_j, ones(1,cnt), N, V, cnt); 
% 
% load([res_dir trk_doc_file], 'trk_doc', 'wei_v', 'K');
% V = 72*48*4;
% topic_table = zeros(K, V);
% trk_doc = cell2mat(trk_doc.');
% for kk = 1:K
%     inds = find(trk_doc==kk);
%     for ii = inds
%         topic_table(kk,:) = topic_table(kk,:) + histc(vis_words{ii},1:V);
%     end
% %     topic_table(kk,:) = topic_table(kk,:) ./ sum(topic_table(kk,:));
%     topic_table(kk,:) = topic_table(kk,:) ./ length(trk_doc);
% end
% 
% save([res_dir 'topic_table_' num2str(wei_v) '_' num2str(K) '.mat'], 'topic_table');