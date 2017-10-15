function [ res_sub_tjc ] = sub_tjc_res( inds_sub_tjcs,tjc_pro )
%SUB_TJC_RES ���ӹ켣���еȵ���������Ϊ������k-means ��׼��
%   �˴���ʾ��ϸ˵�����������ӹ켣��������Ԥ����֮��Ĺ켣
%   ����ǲ���֮����ӹ켣
sum_sub_len = 0;
tot_num_sub = 0;
for ii = 1:length(inds_sub_tjcs)
    tot_num_sub = tot_num_sub + length(inds_sub_tjcs{ii});
    for jj = 1:length(inds_sub_tjcs{ii})
        sum_sub_len = sum_sub_len + length(inds_sub_tjcs{ii}{jj});
    end
end
ave_sub_len = round(sum_sub_len / tot_num_sub);
res_sub_tjc = zeros(tot_num_sub,ave_sub_len*2);
cnt = 0;
%parpool(8)
for ii = 1:length(inds_sub_tjcs)
    fprintf(1, 'resample sub-tjc %d\n', ii);
    tjc_ii = tjc_pro{ii};
    for jj = 1:length(inds_sub_tjcs{ii})
        x0 = tjc_ii(inds_sub_tjcs{ii}{jj},:);
        x1 = tjc_preprocess2(x0,ave_sub_len);
        cnt = cnt+1;
        res_sub_tjc(cnt,1:ave_sub_len) = x1(:,1).';
        res_sub_tjc(cnt,ave_sub_len+1:end) = x1(:,2).';
    end
end

end

