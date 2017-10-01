#!/bin/bash
#Program
#	This program run ./HddCRP.
#History:
#2013/09/02		Guodong Tian	First release

genFileName()
{
	fileName=$2
	fileName=${fileName##*/}
	fileName=${fileName#*_}
	fileName=${fileName%.*}
	fileName="$fileName$(printf '_%.1f_%.1e_%.1e.log' $5 $6 $7)"
	echo $fileName
}

command11="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 100 -alpha1 10 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper101/"
command12="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 10 -alpha1 1 -alpha2 0.1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper102/"
command13="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 1 -alpha1 0.1 -alpha2 0.01 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper103/"
command14="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 1 -alpha1 10 -alpha2 100 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper104/"
command15="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 0.1 -alpha1 1 -alpha2 10 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper105/"
command16="./HddCRPtxt -data ../data/docset1/ -K 25 -alpha0 0.01 -alpha1 0.1 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper106/"

command51="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 100 -alpha1 10 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper501/"
command52="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 10 -alpha1 1 -alpha2 0.1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper502/"
command53="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 1 -alpha1 0.1 -alpha2 0.01 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper503/"
command54="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 1 -alpha1 10 -alpha2 100 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper504/"
command55="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 0.1 -alpha1 1 -alpha2 10 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper505/"
command56="./HddCRPtxt -data ../data/docset5/ -K 25 -alpha0 0.01 -alpha1 0.1 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper506/"

command31="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 100 -alpha1 10 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper301/"
command32="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 10 -alpha1 1 -alpha2 0.1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper302/"
command33="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 1 -alpha1 0.1 -alpha2 0.01 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper303/"
command34="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 1 -alpha1 10 -alpha2 100 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper304/"
command35="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 0.1 -alpha1 1 -alpha2 10 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper305/"
command36="./HddCRPtxt -data ../data/docset3/ -K 25 -alpha0 0.01 -alpha1 0.1 -alpha2 1 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper306/"
#command2="./HddCRP ../dataset/train_station/small/trainss_100_500.mat \
#../dataset/train_station/small/prior.mat \
#500 1 1e-100 1e-20 1 5 1 ./init_ss.mat &"
#logFileName=$(genFileName $command)
#command="$command > $logFileName 2>&1 &"
$command11
$command12
$command13
$command14
$command15
$command16

$command51
$command52
$command53
$command54
$command55
$command56

$command31
$command32
$command33
$command34
$command35
$command36





