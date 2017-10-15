close all;clear all;clc
%计算轨迹之间的距离矩阵，分块计算每块大小是1000
%需要考虑轨迹的起点和终点的时间，位置，速度方向
%存储在testsavepath_block
load D:/code/TEMP/Student003/FeatureExpression/testsavepath_5000/tjc_xyt.mat
temp_dir='./testsavepath_block_5000/';
if ~exist(temp_dir)
    mkdir(temp_dir)
end
At=[];%记录起止时间，第一列表示开始时间，第二列表示结束时间
Ax=[];%记录起止位置，第一,二列表示开始位置，第3，4列表示结束位置
Av=[];%记录起止方向，第一列表示开始方向，第二列表示结束方向
full_size=length(tjc_xyt);
for i=1:1:length(tjc_xyt)
    temp=tjc_xyt{1,i};
    At=[At;temp(1,3) temp(end,3)];
    Ax=[Ax;temp(1,1:2) temp(end,1:2)];
    Av=[Av;compute_direction(temp(:,1:2),1) compute_direction(temp(:,1:2),size(temp,1))];
end
clear temp i;
save ([temp_dir 'At.mat'], 'At')
save ([temp_dir 'Ax.mat'], 'Ax')
save ([temp_dir 'Av.mat'], 'Av')
%%
%计算时间，位置，速度的差值，由于数据点数过多，矩阵无法存储所以计算中要进行分块
load ([temp_dir 'At.mat']);
per=200;
len=ceil(full_size/per);
save([temp_dir 'len.mat'], 'len','per','full_size');%留作后用
for k=1:1:len-1
    at_k=At(1+(k-1)*per:k*per,:);
    save([temp_dir 'at_' num2str(k)],'at_k');
    av_k=Av(1+(k-1)*per:k*per,:);
    save([temp_dir 'av_' num2str(k)],'av_k');
    ax_k=Ax(1+(k-1)*per:k*per,:);
    save([temp_dir 'ax_' num2str(k)],'ax_k');
    clear at_k av_k ax_k;
end
    at_k=At(k*per+1:end,:);
    save([temp_dir 'at_' num2str(len)],'at_k');
    av_k=Av(k*per+1:end,:);
    save([temp_dir 'av_' num2str(len)],'av_k');
    ax_k=Ax(k*per+1:end,:);
    save([temp_dir 'ax_' num2str(len)],'ax_k');
    clear at_k av_k ax_k;
    %%
%时间
%依次取出，并计算长度，做成相同的矩阵
for s=1:1:len
    %使用这些点的起点
    load([temp_dir 'at_' num2str(s) '.mat']);
    size_s=length(at_k);
    t_start=at_k(:,1);
    clear at_k;
    for e=1:1:len 
        %使用这些点的终点
        load([temp_dir 'at_' num2str(e) '.mat']);
        size_e=length(at_k);
        t_end=at_k(:,2)';
        clear at_k;
        T_start=repmat(t_start,1,size_e);
        T_end=repmat(t_end,size_s,1);
        deta_T=T_start-T_end;%矩阵元素若为正，则说明行所代表的轨迹出现在列所代表的轨迹的后面
        %这个式子是在用第j条轨迹的开始时间（同一个时间做成了一个行向量）与每一条轨迹的结束时间（也是一行,但每个元素不同）相减
        %我们要取deta_T中元素大于零小于threshold_T的进行计算
        T_threshold=100;%这里的阈值试自己设定的，因为计算得到均值是1285
        sign_detaT=deta_T;%
        sign_detaT(deta_T<0 | deta_T>T_threshold)=0;
        save([temp_dir 'sign_detaT' num2str(s) '_' num2str(e) '.mat'],'sign_detaT')
        clear sign_detaT t_end T_end deta_T;
    end
    clear t_start T_start;
end
%%
%距离
for s=1:1:len
    %使用这些轨迹的起点位置
    load([temp_dir 'ax_' num2str(s) '.mat']);
    size_s=length(ax_k);
    x_start=ax_k(:,1);
    y_start=ax_k(:,2);
    clear ax_k;
    for e=1:1:len
        %使用这些轨迹的终点
        load([temp_dir 'ax_' num2str(e) '.mat']);
        size_e=length(ax_k);
        x_end=ax_k(:,3)';
        y_end=ax_k(:,4)';
        clear ax_k;
        X_start=repmat(x_start,1,size_e);
        Y_start=repmat(y_start,1,size_e);
        X_end=repmat(x_end,size_s,1);
        Y_end=repmat(y_end,size_s,1);
        %deta_xy矩阵中每一行为改行所代表的轨迹的起点到各个列所代表的轨迹的终点的距离
        deta_X=X_start-X_end;
        deta_Y=Y_start-Y_end;
        dir_deta_xy=atan2(deta_Y,deta_X);%计算位移的方向
        dist_xy=sqrt(deta_X.^2+deta_Y.^2);
        %阈值设计为dist_threshold=100
        dist_threshold=1000;
        sign_dist=dist_xy;
        sign_dist(dist_xy>100)=0;
        save([temp_dir 'dist_xy' num2str(s) '_' num2str(e) '.mat'],'dist_xy');
        save([temp_dir 'sign_dist' num2str(s) '_' num2str(e) '.mat'],'sign_dist')
        save([temp_dir 'dir_deta_xy' num2str(s) '_' num2str(e) '.mat'],'dir_deta_xy');
        clear dist_threshold dist_xy sign_dist sign_deta_xy x_end y_end X_end Y_end X_start Y_start dir_deta_xy;
    end
    clear x_start y_start;
end
%%
%角度
%加入一个轨迹起止点处的角度与起止点位移的夹角，这里还用到上面的距离计算中的式子，所以可以考虑把它们结合到一起去
for s=1:1:len
    %使用这些点的起点速度
    load([temp_dir 'av_' num2str(s) '.mat']);
    size_s=length(av_k);
    v_start=av_k(:,1);
    clear av_k;
    for e=1:1:len
        %使用这些轨迹的终点速度
        load([temp_dir 'av_' num2str(e) '.mat']);
        size_e=length(av_k);
        v_end=av_k(:,2)';
        clear av_k;
        V_start=repmat(v_start,1,size_e);
        V_end=repmat(v_end,size_s,1);
        deta_V=V_start-V_end;%同样以行为索引，行代表的轨迹的起点与每个轨迹的终点进行求差
        V_threshold=1.57;%这里的阈值试自己设定的，PI/4=0.785
        sign_detaV=deta_V;%这是一个角度值介于-pi~pi之间的
        sign_detaV(deta_V<-V_threshold | deta_V>V_threshold)=0;
        load ([temp_dir 'dir_deta_xy' num2str(s) '_' num2str(e) '.mat']);
        deta_startV_xyV=abs(dir_deta_xy-V_start);
        deta_endV_xyV=abs(dir_deta_xy-V_end);
        sign_detaV(deta_startV_xyV > pi/2)=0;%起点方向与位移方向夹角大于90度的排除
        sign_detaV(deta_endV_xyV > pi/2)=0;%终点方向与位移方向夹角大于90度的排除
        save([temp_dir 'sign_detaV' num2str(s) '_' num2str(e) '.mat'],'sign_detaV');
        clear V_end V_start v_end deta_V sign_detaV dir_deta_xy deta_startV_xyV deta_endV_xyV;
    end
    clear v_start;
end
%%
%距离定义为（1-cos（deta_v）)（角度差越大，余弦值越小，（1-余）越大，也就是距离值越大）
%没有连接处的距离定义为无穷
%自己的定义为0
for s=1:1:len
    for e=1:1:len
        load([temp_dir 'sign_detaT' num2str(s) '_' num2str(e) '.mat'])
        load([temp_dir 'sign_dist' num2str(s) '_' num2str(e) '.mat']);
        load([temp_dir 'sign_detaV' num2str(s) '_' num2str(e) '.mat']);
        sign_D=sign(sign_detaT).*sign(sign_dist).*sign(sign_detaV);%得到所有约束的交集
        deta_angle=sign_D.*sign_detaV;%这里位置差也不作为距离定义的内容，只使用角度
        ind=find(deta_angle~=0);
        nzero_per=length(ind)/(size(deta_angle,1)^2);
        D=ones(size(deta_angle))-cos(deta_angle);%构造公式5.3中的第一项
        D(sign_D==0)=inf;%构造公式第三项
        if s==e
            D=D-diag(diag(D));%自己和自己的距离是0%但是由于inf-inf=NaN所以还要再加一部
        end
        D(isnan(D))=0;
        save([temp_dir 'D' num2str(s) '_' num2str(e) '.mat'],'D');
    end
end
