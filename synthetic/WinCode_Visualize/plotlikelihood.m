%
close all;
clear all;
clc
%for i=1:1:4
   % figure(i)
    load(['../result/experiter1000/likelihoods.txt'])
    plot([1:size(likelihoods,2)], likelihoods,'-')
%end