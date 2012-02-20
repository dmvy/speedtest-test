#!/bin/bash

cd ~/speedtest

HOSTS=( $(cat hosts))
HOSTS_cnt=`cat hosts|wc -l`
for ((i=0;  i<$HOSTS_cnt*5-1; i+=5)); do
	HOST=${HOSTS[i+2]}
	FILE=${HOSTS[i+3]}
	echo $HOST $FILE
	if [ ! -d $HOST ]; then
		mkdir $HOST
		touch $HOST/speed.log
	fi
	/usr/bin/wget --progress=dot:mega -o $HOST/wget.log -O /dev/null http://$HOST/$FILE
	grep saved $HOST/wget.log >> $HOST/speed.log
	DT=`date +%Y-%m-%d_%H-%M`
	/usr/bin/mtr -wrc100 $HOST > $HOST/$DT.mtr &
done;
./analyse.sh