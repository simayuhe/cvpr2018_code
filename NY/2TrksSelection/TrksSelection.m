%读取GKTL提取的轨迹文档：klt_3000_10_trk.txt
%从中筛选，（分组），得到轨迹进行简单滤波显示和固定格式的存储
%两种格式，一种是.mat另一种是每篇文档存一个TXT %不对，这里还没有必要每篇文档存一个txt
close all
clear all;
clc
rawfilepath='../1GKLT-master/NYimages4000/';
rawfilename=[rawfilepath 'klt_3000_10_trk.txt'];
savepath='../data/data4000frames/';%用来存储原始数据，包括（.mat .txt backgroud.jpg）
if ~exist(savepath)
    mkdir(savepath)
end
fid=fopen(rawfilename,'r');
i=0;
while feof(fid)==0
    len = fscanf(fid,'%d');
    if len>5

        A=fscanf(fid,'(%d,%d,%d)');%这个A会把整行数据都读出来放在一个向量里
        if (max(A(1:3:end))-min(A(1:3:end)))>15 && (max(A(2:3:end))-min(A(2:3:end)))>15 %整个轨迹变动幅度太小，被视为驻点去掉
        i=i+1;
        Trks(i).num=len;
        Trks(i).x=A(1:3:end);
        Trks(i).y=A(2:3:end);
        Trks(i).t=A(3:3:end);
        end
%         line=fgetl(fid);
%         fidsave=fopen([savepath 'doc_' num2str(i) '.txt'], 'w');
%         fprintf(fidsave,line);
%         clear line
%         fclose(fidsave);
    else
         tline=fgetl(fid);
         clear tline;
    end
end
fclose(fid);
save([savepath 'Trks.mat'],'Trks');
%%
h=imread([rawfilepath '000000.jpg']);
imwrite(h,[savepath 'background.jpg']);
%%
%验证轨迹提取效果
htemp=imread([savepath 'background.jpg']);

imshow(htemp);
hold on 
for i=1:1:length(Trks)
    plot(Trks(i).x,Trks(i).y,'y-','LineWidth',1);
end
hold off

imwrite(htemp,['BackAndTrj.jpg']);
% for j=1:1:len
%     Trks(i)
% while (len) > 0    
%     i = i + 1;
%     trk(i).ss=fscanf(fid,'[%d,%d]');
%     A = fscanf(fid,'(%d,%d,%d)');
%      
%     trk(i).x = A(1:3:end);
%     trk(i).y = A(2:3:end);
%     trk(i).t = A(3:3:end);
%    
%     len = fscanf(fid,'%d');
% end

% tline=fgetl(fid);
% tline(1)
% fclose(fid);
% while feof(fid)==0
%     tline=fgetl(fid);
% end

%%
% %根据背景 和 目前轨迹情况标注出入口信息
%close all;clear all;clc
figure(2)
backimage=imshow('BackAndTrj.jpg');
num_ss=8
for i=1:1:num_ss
    h=imrect;
    position(i,:)=wait(h);
end
save('ss_position.mat','position')

%%
%
%close all ;clear all;clc

load ([savepath 'Trks.mat'])
load ss_position.mat
for i=1:1:length(Trks)
    Trks(i).ss=[0; 0];
    x_start=Trks(i).x(1,1);x_end=Trks(i).x(end,1);
    y_start=Trks(i).y(1,1);y_end=Trks(i).y(end,1);
    %%%%%%%%%%  1
    for j=1:1:size(position,1)
        if x_start>position(j,1) && (x_start<position(j,1)+position(j,3)) && y_start>position(j,2) && (y_start<position(j,2)+position(j,4))
            Trks(i).ss(1,1)=j;
        end
        if x_end>position(j,1) && (x_end<position(j,1)+position(j,3)) && y_end>position(j,2) && (y_end<position(j,2)+position(j,4))
            Trks(i).ss(2,1)=j;
        end        
    end
end
save([savepath 'Trks.mat'],'Trks')
%%
%