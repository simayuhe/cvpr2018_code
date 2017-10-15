function plot_tjcs3(tjc,idx,varargin)
if size(idx,1)~=1
    idx = idx';
end
if ~isempty(varargin)
	axis(varargin{1});
end
if length(varargin)>1
	I = varargin{2};
% 	I = flipdim(I,1);
	imshow(I);
% 	axis xy
end
if length(varargin)>2
    color = varargin{3};
else
    color = [0 0 1];
end
    
hold on
for ii = idx
    tjc_ii = tjc{ii};
    len_ii = size(tjc_ii,1);
    if len_ii > 5
        plot(tjc_ii(1:end,1),tjc_ii(1:end,2),'Color',color);
%         plot(tjc_ii(end-5:end,1),tjc_ii(end-5:end,2),'r');
    else
        plot(tjc_ii(1:end,1),tjc_ii(1:end,2),'r');
    end
end