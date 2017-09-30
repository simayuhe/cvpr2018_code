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

command1="./HddCRP ../dataset/train_station/small/trainss_100_500.mat \
../dataset/train_station/small/prior.mat \
500 1 1e-50 1e-10 1 5 1 ./init_ss.mat &"
command2="./HddCRP ../dataset/train_station/small/trainss_100_500.mat \
../dataset/train_station/small/prior.mat \
500 1 1e-100 1e-20 1 5 1 ./init_ss.mat &"
#logFileName=$(genFileName $command)
#command="$command > $logFileName 2>&1 &"
$command1
$command2
