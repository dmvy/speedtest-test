#!/bin/bash

cd ~/speedtest

IP=127.0.0.1

HOSTS=( $(cat hosts))
HOSTS_cnt=`cat hosts|wc -l`
for ((i=0;  i<$HOSTS_cnt*4-1; i+=4)); do
	HOST=${HOSTS[i+2]}
	FILE=${HOSTS[i+3]}
	echo $HOST $FILE
	if [ ! -d $HOST ]; then
		mkdir $HOST
		touch $HOST/speed.log
	fi
	/usr/bin/wget --bind-address=$IP --progress=dot:mega -o $HOST/wget.log -O /dev/null -T 5 -t 1 http://$HOST/$FILE
	grep saved $HOST/wget.log >> $HOST/speed.log
	DT=`date +%Y-%m-%d_%H-%M`
	/usr/bin/mtr --address $IP -wrc100 $HOST > $HOST/$DT.mtr &
done;
./analyse.sh
