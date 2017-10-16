function [ features ] = generate_feature( Y,n_dim )
%GENERATE_FEATURE 此处显示有关此函数的摘要
%   此处显示详细说明
T = size(Y,2)/2;
w = 100;%速度的权重
Y = [Y w*(Y(:,2:T)-Y(:,1:T-1)) w*(Y(:,T+2:end)-Y(:,T+1:end-1))];
[COEFF,SCORE,latent] = princomp(Y);
features = SCORE(:,1:n_dim);
    