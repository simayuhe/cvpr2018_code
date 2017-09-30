%
close all;
clear all;
clc
load('../result/exper1/likelihoods.txt')
plot([1:size(likelihoods,2)], likelihoods)
