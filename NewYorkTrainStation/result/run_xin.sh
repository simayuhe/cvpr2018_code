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

command1="./HddCRPtxt -data ../data/halfdata/ -link ../data/halfdata -K 500 -alpha0 1 -alpha1 1e-2 -alpha2 1e-3 -num_burn_in 1 -num_samples 500 -num_space 1 -save_dir ../result/exper3/ -init_ss ../data/halfdata"
command4="./HddCRPtxt -data ../data/halfdata/ -link ../data/halfdata -K 500 -alpha0 1e-10 -alpha1 1e-20 -alpha2 1e-30 -num_burn_in 1 -num_samples 500 -num_space 1 -save_dir ../result/exper4/ -init_ss ../data/halfdata"
command6="./HddCRPtxt -data ../data/halfdata/ -link ../data/halfdata -K 500 -alpha0 1e-10 -alpha1 1e-20 -alpha2 1e-30 -num_burn_in 5 -num_samples 500 -num_space 1 -save_dir ../result/exper6/ -init_ss ../data/halfdata"
command501="./HddCRPtxt -data ../data/completedata/ -link ../data/completedata -K 1000 -alpha0 1e-20 -alpha1 1e-80 -alpha2 1e-150 -num_burn_in 5 -num_samples 100 -num_space 1 -save_dir ../result/exper501/ -init_ss ../data/completedata"
command502="./HddCRPtxt -data ../data/completedata/ -link ../data/completedata -K 1000 -alpha0 1e-10 -alpha1 1e-100 -alpha2 1e-200 -num_burn_in 10 -num_samples 100 -num_space 1 -save_dir ../result/exper502/ -init_ss ../data/completedata"
#command2="./HddCRP ../dataset/train_station/small/trainss_100_500.mat \
#../dataset/train_station/small/prior.mat \
#500 1 1e-100 1e-20 1 5 1 ./init_ss.mat &"
#logFileName=$(genFileName $command)
#command="$command > $logFileName 2>&1 &"
#$command1
#$command6
$command502





