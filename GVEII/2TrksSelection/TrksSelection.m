%读取GKTL提取的轨迹文档：klt_3000_10_trk.txt
%从中筛选，（分组），得到轨迹进行简单滤波显示和固定格式的存储
%两种格式，一种是.mat另一种是每篇文档存一个TXT %不对，这里还没有必要每篇文档存一个txt
close all
clear all;
clc
rawfilepath='../1GKLT-master/GVEII/';
rawfilename=[rawfilepath 'klt_3000_10_trk.txt'];
savepath='../data/data2400frames/';%用来存储原始数据，包括（.mat .txt backgroud.jpg）
if ~exist(savepath)
    mkdir(savepath)
end
fid=fopen(rawfilename,'r');
i=0;
while feof(fid)==0
    len = fscanf(fid,'%d');
    if len>20

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
h=imread([rawfilepath '000000.jpeg']);
imwrite(h,[savepath 'background.jpeg']);
%%
%验证轨迹提取效果
imshow([savepath 'background.jpeg']);

hold on 
for i=1:1:length(Trks)
plot(Trks(i).x,Trks(i).y,'y-','LineWidth',1);
end
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