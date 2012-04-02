#!/bin/bash

rm index.html

echo "<html> 
<head> 
<title>SpeedTest</title>
<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" >
<meta http-equiv=\"refresh\" content=\"1800\">
</head>
<body> 
<center>"> index.html
HOSTS=( $(cat hosts))
echo ${HOSTS[@]}
HOSTS_cnt=`cat hosts|wc -l`
for ((i=0;i<$HOSTS_cnt*4-1; i+=4)); do 
	CITY=${HOSTS[i+0]}
	ISP=${HOSTS[i+1]}
	HOST=${HOSTS[i+2]} 
	echo "<div>Город: <b>$CITY</b>; Оператор: <b>$ISP</b>; Сервер: <b>$HOST</b>;</div>" >> index.html
	echo "<img src=png/${HOST}_week.png /><img src=png/${HOST}_day.png /></br>" >> index.html
done;

echo "</center>
</body>
</html>" >> index.html

