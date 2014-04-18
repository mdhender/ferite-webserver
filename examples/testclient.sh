#! /bin/bash

httpRequest() {
	wget -T 2 http://localhost:9090/counter -O - 2> /dev/null |
	grep -E 'Count = [0-9]+'
}

while [ true ];do
	START=`date +%s%N`
	if [ "`httpRequest`" != "" ];then
		NOW=`date +%s%N`
		echo $[ ( $NOW - $START ) / 1000000 ] >> .stats.raw
	else
		echo . >> .stats.error
	fi
	sleep 1
done
