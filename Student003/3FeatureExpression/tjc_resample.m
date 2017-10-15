function [ tjc_res ,len_tjc ] = tjc_resample( tjc_den,do_det_odd,do_plot,ds )
%TJC_RESAMPLE 此处显示有关此函数的摘要
%   此处显示详细说明
for ii = 1:length(tjc_den)
%      if ii==40528
%        tjc_res{ii}=tjc_den{ii};
%        len_tjc(ii)=length(tjc_den{ii});
%        continue;
%     end
    fprintf(1, 'resample tjc %d\n', ii);
    x = tjc_den{ii};
    dx = x(2:end,:)-x(1:end-1,:);
    int = sqrt(sum(dx.*dx,2));
    int = mean(int);
    scale = 2 / int;
    x = scale*x;
    if do_det_odd
        y = tjc_preprocess3(x,ds,0,5);
    else
        y = tjc_preprocess(x,ds,0);
    end        
    y = y ./ scale;
    len_tjc(ii) = (size(y,1)-1)*ds/scale;
    tjc_res{ii} = y;
    if do_plot
        clf
        h=figure;
        subplot(121)
        plot(tjc_den{ii}(:,1),tjc_den{ii}(:,2),'.-');
        subplot(122)
        plot(y(:,1),y(:,2),'.-');
        title(num2str(ii));
        input('Press enter to continue:');
        figure(h);
    end
end

end

