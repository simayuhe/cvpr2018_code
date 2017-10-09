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

command11="./HddCRPtxt -data ../data/halfdata/ -K 500 -alpha0 1 -alpha1 1e-2 -alpha2 1e-4 -num_burn_in 1 -num_samples 100 -num_space 1 -save_dir ../result/exper3/"

#command2="./HddCRP ../dataset/train_station/small/trainss_100_500.mat \
#../dataset/train_station/small/prior.mat \
#500 1 1e-100 1e-20 1 5 1 ./init_ss.mat &"
#logFileName=$(genFileName $command)
#command="$command > $logFileName 2>&1 &"
$command11





