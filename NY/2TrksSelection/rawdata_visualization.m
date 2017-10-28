
%对原始数据进行可视化处理
close all;
clear all;
clc;
originalfilename= '../data/data4000frames/Trks.mat';
%%%%%%%%%%%%%%%%%%%%%
load(originalfilename)
trks=Trks;
%%
%1用高斯分布拟合起止点，并展示在图中
%找到每个有标记的起止点附近的位置坐标
SS=cell(1,8);

idx_completetrj=[];
idx_SourceKnowntrj=[];
idx_SinkKnowntrj=[];
idx_UnknownSStrj=[];

for idx_trk=1:1:size(trks,2)
%trks(1,idx_trk).ss(1,1)
for si=1:1:size(SS,2)
    if trks(1,idx_trk).ss(1,1)==si
        SS{1,si}=[SS{1,si} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
    end
    if trks(1,idx_trk).ss(2,1)==si
        SS{1,si}=[SS{1,si} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
    end
end
%     switch trks(1,idx_trk).ss(1,1)
%         case 1
%             SS{1,1}=[SS{1,1} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%            % continue;
%         case 2
%             SS{1,2}=[SS{1,2} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%             %continue;
%         case 3
%             SS{1,3}=[SS{1,3} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%             %continue;            
%         case 4
%             SS{1,4}=[SS{1,4} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%             %continue; 
%          case 5
%             SS{1,5}=[SS{1,5} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%            % continue; 
%         case 6
%             SS{1,6}=[SS{1,6} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%            % continue; 
%         case 7
%             SS{1,7}=[SS{1,7} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%           %  continue; 
%         case 8
%             SS{1,8}=[SS{1,8} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%           %  continue; 
%                   case 9
%             SS{1,9}=[SS{1,9} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%                       case 10
%             SS{1,10}=[SS{1,10} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%                                   case 11
%             SS{1,11}=[SS{1,11} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%                                               case 12
%             SS{1,12}=[SS{1,12} [trks(1,idx_trk).x(1:3,:) trks(1,idx_trk).y(1:3,:)]'];
%           %  continue; 
%         otherwise
%           %  continue; 
%     end
%     switch trks(1,idx_trk).ss(2,1)
%         case 1
%             SS{1,1}=[SS{1,1} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%             %continue;
%         case 2
%             SS{1,2}=[SS{1,2} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%             %continue;
%         case 3
%             SS{1,3}=[SS{1,3} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%             %continue;            
%         case 4
%             SS{1,4}=[SS{1,4} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%            % continue; 
%          case 5
%             SS{1,5}=[SS{1,5} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%             %continue; 
%         case 6
%             SS{1,6}=[SS{1,6} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%            % continue; 
%         case 7
%             SS{1,7}=[SS{1,7} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%           %  continue; 
%         case 8
%             SS{1,8}=[SS{1,8} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%                     case 9
%             SS{1,9}=[SS{1,9} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%                                 case 10
%             SS{1,10}=[SS{1,10} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%                                 case 11
%             SS{1,11}=[SS{1,11} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%                                 case 12
%             SS{1,12}=[SS{1,12} [trks(1,idx_trk).x(end-3:end,:) trks(1,idx_trk).y(end-3:end,:)]'];
%            % continue; 
%         otherwise
%            % continue; 
%     end

    if (trks(1,idx_trk).ss(1,1)>0) && (trks(1,idx_trk).ss(2,1)>0)
        idx_completetrj=[idx_completetrj idx_trk];
    else if (trks(1,idx_trk).ss(1,1)>0) && (trks(1,idx_trk).ss(2,1)==0)
            idx_SourceKnowntrj=[idx_SourceKnowntrj idx_trk];
        else if (trks(1,idx_trk).ss(1,1)==0) && (trks(1,idx_trk).ss(2,1)>0)
                idx_SinkKnowntrj=[idx_SinkKnowntrj idx_trk];
            else
                idx_UnknownSStrj=[idx_UnknownSStrj idx_trk];
            end
        end
    end
end
save('../data/SS.mat','SS')
save('../data/idx_ss.mat','idx_SinkKnowntrj','idx_completetrj','idx_SourceKnowntrj','idx_UnknownSStrj');
%%
% 
%用高斯分布拟合坐标点集，即已知目标点符合单高斯分布，求出分布参数
h=imshow('../data/data500frames/background.jpg')
hold on
MySample=SS{1,1}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.99);
text(avg(1),avg(2),{'1'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30

MySample=SS{1,2}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.95);
text(avg(1),avg(2),{'2'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30

MySample=SS{1,3}';
%plot(MySample(:,1),MySample(:,2),'r+');[avg,covariance]=error_ellipse_f(MySample,0.95);
[avg,covariance]=error_ellipse_f(MySample,0.95);
text(avg(1),avg(2),{'3'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30

MySample=SS{1,4}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.95);
text(avg(1),avg(2),{'4'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
MySample=SS{1,5}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.8);
text(avg(1),avg(2),{'5'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
MySample=SS{1,6}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.8);
text(avg(1),avg(2),{'6'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
MySample=SS{1,7}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.8);
text(avg(1),avg(2),{'7'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
MySample=SS{1,8}';
%plot(MySample(:,1),MySample(:,2),'r+');
[avg,covariance]=error_ellipse_f(MySample,0.95);
text(avg(1),avg(2),{'8'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
% MySample=SS{1,9}';
% %plot(MySample(:,1),MySample(:,2),'r+');
% [avg,covariance]=error_ellipse_f(MySample,0.95);
% text(avg(1),avg(2),{'9'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
% 
% MySample=SS{1,10}';
% %plot(MySample(:,1),MySample(:,2),'r+');
% [avg,covariance]=error_ellipse_f(MySample,0.95);
% text(avg(1),avg(2),{'10'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
% MySample=SS{1,11}';
% %plot(MySample(:,1),MySample(:,2),'r+');
% [avg,covariance]=error_ellipse_f(MySample,0.7);
% text(avg(1),avg(2),{'11'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30
% MySample=SS{1,12}';
% %plot(MySample(:,1),MySample(:,2),'r+');
% [avg,covariance]=error_ellipse_f(MySample,0.7);
% text(avg(1),avg(2),{'12'},'Backgroundcolor',[.7 .9 .7],'FontSize',18);%,'Linewidth',30




%hold off;
saveas(h,'../data/SS.jpg');
% %%
% %绘制部分轨迹表明tracklets 的种类
% ind=30;%length(idx_completetrj)
% plot(trks(idx_completetrj(ind)).x(:,1),trks(idx_completetrj(ind)).y(:,1),'b-','Linewidth',4);
% % ind=32;
% % plot(trks(idx_completetrj(ind)).x(:,1),trks(idx_completetrj(ind)).y(:,1),'b-','Linewidth',4);
% 
% %%
% 
% % ind=5200;%length(idx_completetrj)
% % plot(trks(idx_SinkKnowntrj(ind)).x(:,1),trks(idx_SinkKnowntrj(ind)).y(:,1),'r-','Linewidth',4);
% ind=587;
% plot(trks(idx_SourceKnowntrj(ind)).x(:,1),trks(idx_SourceKnowntrj(ind)).y(:,1),'r-','Linewidth',4);
% 
% %%
% ind=500;%length(idx_completetrj)
% plot(trks(idx_UnknownSStrj(ind)).x(:,1),trks(idx_UnknownSStrj(ind)).y(:,1),'g-','Linewidth',4);
% ind=5987;
% plot(trks(idx_UnknownSStrj(ind)).x(:,1),trks(idx_UnknownSStrj(ind)).y(:,1),'g-','Linewidth',4);
% 
% hold off 
% saveas(h,'../data/eg_trj.jpg');
