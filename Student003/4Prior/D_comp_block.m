close all;clear all;clc
%����켣֮��ľ�����󣬷ֿ����ÿ���С��1000
%��Ҫ���ǹ켣�������յ��ʱ�䣬λ�ã��ٶȷ���
%�洢��testsavepath_block
load ~/cvpr2018_code/Student003/3FeatureExpression/testsavepath_5000/tjc_xyt.mat
temp_dir='./testsavepath_block_5000/';
if ~exist(temp_dir)
    mkdir(temp_dir)
end
At=[];%��¼��ֹʱ�䣬��һ�б�ʾ��ʼʱ�䣬�ڶ��б�ʾ����ʱ��
Ax=[];%��¼��ֹλ�ã���һ,���б�ʾ��ʼλ�ã���3��4�б�ʾ����λ��
Av=[];%��¼��ֹ���򣬵�һ�б�ʾ��ʼ���򣬵ڶ��б�ʾ������
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
%����ʱ�䣬λ�ã��ٶȵĲ�ֵ��������ݵ����࣬�����޷��洢���Լ�����Ҫ���зֿ�
load ([temp_dir 'At.mat']);
per=200;
len=ceil(full_size/per);
save([temp_dir 'len.mat'], 'len','per','full_size');%��������
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
%ʱ��
%����ȡ���������㳤�ȣ�������ͬ�ľ���
for s=1:1:len
    %ʹ����Щ������
    load([temp_dir 'at_' num2str(s) '.mat']);
    size_s=length(at_k);
    t_start=at_k(:,1);
    clear at_k;
    for e=1:1:len 
        %ʹ����Щ����յ�
        load([temp_dir 'at_' num2str(e) '.mat']);
        size_e=length(at_k);
        t_end=at_k(:,2)';
        clear at_k;
        T_start=repmat(t_start,1,size_e);
        T_end=repmat(t_end,size_s,1);
        deta_T=T_start-T_end;%����Ԫ����Ϊ����˵��������Ĺ켣������������Ĺ켣�ĺ���
        %���ʽ�������õ�j���켣�Ŀ�ʼʱ�䣨ͬһ��ʱ��������һ������������ÿһ���켣�Ľ���ʱ�䣨Ҳ��һ��,��ÿ��Ԫ�ز�ͬ�����
        %����Ҫȡdeta_T��Ԫ�ش�����С��threshold_T�Ľ��м���
        T_threshold=100;%�������ֵ���Լ��趨�ģ���Ϊ����õ���ֵ��1285
        sign_detaT=deta_T;%
        sign_detaT(deta_T<0 | deta_T>T_threshold)=0;
        save([temp_dir 'sign_detaT' num2str(s) '_' num2str(e) '.mat'],'sign_detaT')
        clear sign_detaT t_end T_end deta_T;
    end
    clear t_start T_start;
end
%%
%����
for s=1:1:len
    %ʹ����Щ�켣�����λ��
    load([temp_dir 'ax_' num2str(s) '.mat']);
    size_s=length(ax_k);
    x_start=ax_k(:,1);
    y_start=ax_k(:,2);
    clear ax_k;
    for e=1:1:len
        %ʹ����Щ�켣���յ�
        load([temp_dir 'ax_' num2str(e) '.mat']);
        size_e=length(ax_k);
        x_end=ax_k(:,3)';
        y_end=ax_k(:,4)';
        clear ax_k;
        X_start=repmat(x_start,1,size_e);
        Y_start=repmat(y_start,1,size_e);
        X_end=repmat(x_end,size_s,1);
        Y_end=repmat(y_end,size_s,1);
        %deta_xy������ÿһ��Ϊ��������Ĺ켣����㵽����������Ĺ켣���յ�ľ���
        deta_X=X_start-X_end;
        deta_Y=Y_start-Y_end;
        dir_deta_xy=atan2(deta_Y,deta_X);%����λ�Ƶķ���
        dist_xy=sqrt(deta_X.^2+deta_Y.^2);
        %��ֵ���Ϊdist_threshold=100
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
%�Ƕ�
%����һ���켣��ֹ�㴦�ĽǶ�����ֹ��λ�Ƶļнǣ����ﻹ�õ�����ľ�������е�ʽ�ӣ����Կ��Կ��ǰ����ǽ�ϵ�һ��ȥ
for s=1:1:len
    %ʹ����Щ�������ٶ�
    load([temp_dir 'av_' num2str(s) '.mat']);
    size_s=length(av_k);
    v_start=av_k(:,1);
    clear av_k;
    for e=1:1:len
        %ʹ����Щ�켣���յ��ٶ�
        load([temp_dir 'av_' num2str(e) '.mat']);
        size_e=length(av_k);
        v_end=av_k(:,2)';
        clear av_k;
        V_start=repmat(v_start,1,size_e);
        V_end=repmat(v_end,size_s,1);
        deta_V=V_start-V_end;%ͬ������Ϊ�����д��Ĺ켣�������ÿ���켣���յ�������
        V_threshold=1.57;%�������ֵ���Լ��趨�ģ�PI/4=0.785
        sign_detaV=deta_V;%����һ���Ƕ�ֵ����-pi~pi֮���
        sign_detaV(deta_V<-V_threshold | deta_V>V_threshold)=0;
        load ([temp_dir 'dir_deta_xy' num2str(s) '_' num2str(e) '.mat']);
        deta_startV_xyV=abs(dir_deta_xy-V_start);
        deta_endV_xyV=abs(dir_deta_xy-V_end);
        sign_detaV(deta_startV_xyV > pi/2)=0;%��㷽����λ�Ʒ���нǴ���90�ȵ��ų�
        sign_detaV(deta_endV_xyV > pi/2)=0;%�յ㷽����λ�Ʒ���нǴ���90�ȵ��ų�
        save([temp_dir 'sign_detaV' num2str(s) '_' num2str(e) '.mat'],'sign_detaV');
        clear V_end V_start v_end deta_V sign_detaV dir_deta_xy deta_startV_xyV deta_endV_xyV;
    end
    clear v_start;
end
%%
%���붨��Ϊ��1-cos��deta_v��)���ǶȲ�Խ������ֵԽС����1-�ࣩԽ��Ҳ���Ǿ���ֵԽ��
%û�����Ӵ��ľ��붨��Ϊ����
%�Լ��Ķ���Ϊ0
for s=1:1:len
    for e=1:1:len
        load([temp_dir 'sign_detaT' num2str(s) '_' num2str(e) '.mat'])
        load([temp_dir 'sign_dist' num2str(s) '_' num2str(e) '.mat']);
        load([temp_dir 'sign_detaV' num2str(s) '_' num2str(e) '.mat']);
        sign_D=sign(sign_detaT).*sign(sign_dist).*sign(sign_detaV);%�õ�����Լ��Ľ���
        deta_angle=sign_D.*sign_detaV;%����λ�ò�Ҳ����Ϊ���붨������ݣ�ֻʹ�ýǶ�
        ind=find(deta_angle~=0);
        nzero_per=length(ind)/(size(deta_angle,1)^2);
        D=ones(size(deta_angle))-cos(deta_angle);%���칫ʽ5.3�еĵ�һ��
        D(sign_D==0)=inf;%���칫ʽ������
        if s==e
            D=D-diag(diag(D));%�Լ����Լ��ľ�����0%��������inf-inf=NaN���Ի�Ҫ�ټ�һ��
        end
        D(isnan(D))=0;
        save([temp_dir 'D' num2str(s) '_' num2str(e) '.mat'],'D');
    end
end
