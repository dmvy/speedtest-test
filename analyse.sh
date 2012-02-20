#!/bin/sh

if [ ! -d rrd ]; then
                mkdir rrd
fi

if [ ! -d png ]; then
                mkdir png
fi

for host in `cat hosts|cut -f 3`; do
	if [ ! -e rrd/${host}.rrd ]; then
	faketime "2011-01-01 00:00:00" rrdtool create \
		-s 1800sec \
		rrd/${host}.rrd \
		DS:speed:GAUGE:3600:U:U \
		RRA:AVERAGE:0.5:1:1440 \
	        RRA:AVERAGE:0.5:24:356 \
	        RRA:AVERAGE:0.5:356:10 \
		RRA:MAX:0.5:1:1440 \
	        RRA:MAX:0.5:24:356 \
	        RRA:MAX:0.5:356:10 \
		RRA:LAST:0.5:1:1440 \
	        RRA:LAST:0.5:24:356 \
	        RRA:LAST:0.5:356:10
	fi
	
	for value in `cat $host/speed.log | tail -n 1 | cut -d ")" -f 1 | sed "s/(//"|sed "s/,/\./"|awk '
	{
		if ($4 == "MB/s") {
			speed = $3*1000;
			} else {
			speed = $3
			}
		print($1 "_" $2 ";" speed);
	}'`; do
		echo "$host\t$value"
		TIME=`echo $value|cut -d ";" -f 1|sed "s/_/ /"`
		SPEED=`echo $value|cut -d ";" -f 2`
		faketime "$TIME" rrdtool update rrd/${host}.rrd N:$SPEED
	done;
	./graph.sh $host week
	./graph.sh $host day
done;

