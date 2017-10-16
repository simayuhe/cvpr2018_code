function vhddcrp2vrft( res_dir,K)
%VHDDCRP2VRFT �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��,�ϲ��Ӿ������õ��ʵ��켣Ƭ�εı任������ӹ켣Ƭ�ε��Ӿ����ʵı任����
%  K��ʾ���൥�ʴʵ䳤��
load ([res_dir 'tjc_encoded'])
%load trainss_100_500.mat
doc_on_V1=[];%ddcrf�е��ĵ���������Ŀ��K
for i=1:1:length(tjc_encoded)  
        doc_on_V1=[doc_on_V1;tjc_encoded{i}'];  
end
load([res_dir 'vis_words.mat'])
% doc_on_V2=[];%rft�е��ĵ���������Ŀ��48*72*4=13824
tI=imread('../data/data5000frames/background.jpg');
P=zeros(K,round(size(tI,1)/10)*round(size(tI,2)/10)*4);
for ii=1:1:K%��ÿһ��V1�еĵ���
    ind{ii}=find(doc_on_V1==ii);%�ҳ���Щ�������ĵ��ж�Ӧ��λ��
    for jj=1:1:length(ind{ii})
        ind_jj=ind{ii}(jj);
        sent_in_V2=vis_words{ind_jj};%�ĵ��е�һ��
        for pp=1:1:length(sent_in_V2)
            value=sent_in_V2(pp);%һ���е��ʣ�V2�ʵ��µģ�
            P(ii,value)=P(ii,value)+1;
        end
    end
end
save ([res_dir 'P_' num2str(K) '.mat'],'P')

end

