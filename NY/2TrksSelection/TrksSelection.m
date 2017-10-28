%��ȡGKTL��ȡ�Ĺ켣�ĵ���klt_3000_10_trk.txt
%����ɸѡ�������飩���õ��켣���м��˲���ʾ�͹̶���ʽ�Ĵ洢
%���ָ�ʽ��һ����.mat��һ����ÿƪ�ĵ���һ��TXT %���ԣ����ﻹû�б�Ҫÿƪ�ĵ���һ��txt
close all
clear all;
clc
rawfilepath='../1GKLT-master/NYimages4000/';
rawfilename=[rawfilepath 'klt_3000_10_trk.txt'];
savepath='../data/data4000frames/';%�����洢ԭʼ���ݣ�������.mat .txt backgroud.jpg��
if ~exist(savepath)
    mkdir(savepath)
end
fid=fopen(rawfilename,'r');
i=0;
while feof(fid)==0
    len = fscanf(fid,'%d');
    if len>5

        A=fscanf(fid,'(%d,%d,%d)');%���A����������ݶ�����������һ��������
        if (max(A(1:3:end))-min(A(1:3:end)))>15 && (max(A(2:3:end))-min(A(2:3:end)))>15 %�����켣�䶯����̫С������Ϊפ��ȥ��
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
%��֤�켣��ȡЧ��
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
% %���ݱ��� �� Ŀǰ�켣�����ע�������Ϣ
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