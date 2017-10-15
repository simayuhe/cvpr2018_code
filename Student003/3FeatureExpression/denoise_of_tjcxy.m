function [ tjc_den ] = denoise_of_tjcxy( tjc ,do_plot)
%DENOISE_OF_TJCXY ��tjc_xy ���н��봦��
%   ����һ���켣��n��cell��ÿ��cell��nn��2�У����Թ켣�����˲�֮�������
n=length(tjc);
tjc_den = cell(n,1);
for ii=1:1:n
    %ii
   tjc_temp{ii}=tjc_denoise4(tjc{ii},8);
   tjc_den{ii}=tjc_denoise2(tjc_temp{ii});
%    tjc_den{ii}=tjc_denoise2(tjc{ii});
    if do_plot
        clf
        h = figure;
        subplot(131)
        hold on;
        plot(tjc{ii}(:,1),tjc{ii}(:,2),'.-');
        plot(tjc{ii}(end,1),tjc{ii}(end,2),'.-r');
%         title(['class' num2str(labels(ii))])
        subplot(132)
        hold on;
        plot(tjc_temp{ii}(:,1),tjc_temp{ii}(:,2),'.-');
        plot(tjc_temp{ii}(end,1),tjc_temp{ii}(end,2),'.-r');
          subplot(133)
        hold on ;
        plot(tjc_den{ii}(:,1),tjc_den{ii}(:,2),'.-');
        plot(tjc_den{ii}(end,1),tjc_den{ii}(end,2),'.-r');
        title(['index' num2str(ii)]);
        input('press enter to continue:');
        figure(h);
    end
end

end

