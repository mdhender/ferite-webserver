#! /bin/bash

timestamp(){
	t=`date +%s%N`
	echo $[ $t / 1000000 ]
}

NUMBER_OF_CLIENTS=$1;
TOTAL_REQUESTS=0
START_TIME=`timestamp`

spawn() {
	n=$1
	command=$2
	while [ $(( n -= 1 )) -ge 0 ]
	do
		$command &
	done
}

i=0
#spinner='/-\|'
#spinner='.oOo'
#spinner='.oO0Oo'
spinner='/-\|/-\|'
interval=`echo 1/${#spinner} | bc -l`

killclients() {
	CLIENTS=$(ps aux | awk '
		/awk|ps/ {next}
		/testclient.sh/ {print $2}
	')
	for x in $CLIENTS;do
		kill -9 $x &> /dev/null
	done
	echo
	echo Stress test terminated
	exit
}

sum() {
	FILENAME=$1
	awk '{s+=$1} END {print s}' $FILENAME
}

echo  > .stats.raw
echo  > .stats.error

if [ "$NUMBER_OF_CLIENTS" != "" ];then
	spawn $NUMBER_OF_CLIENTS ./testclient.sh
	
	trap killclients SIGINT
	trap killclients SIGTERM
	
	REPORT="Starting up test clients... "
	THEN=$START_TIME
	
	while [ true ];do
		i=$[ ($i+1)%${#spinner} ]
		
		if (( $i == 0 ));then
			NOW=`timestamp`
			REQUESTS=$[ `cat .stats.raw|wc -l` - 1 ]
			INTERVAL_SUM=`sum .stats.raw`
			echo > .stats.raw
			if (( $REQUESTS > 0 ));then
				ERRORS=$[ `cat .stats.error|wc -l` - 1 ]
				TOTAL_REQUESTS=$[ $TOTAL_REQUESTS + $REQUESTS ]
				INTERVAL_AVERAGE=$[ $INTERVAL_SUM / $REQUESTS ]
		
				RATE=$[ ( $REQUESTS * 1000 ) / ( $NOW - $THEN ) ]
				AVERAGE=$[ ( $TOTAL_REQUESTS * 1000 ) / ( $NOW - $START_TIME ) ]
			
				REPORT="Request per second: $RATE (average: $AVERAGE)."
				REPORT="$REPORT Average time: $INTERVAL_AVERAGE ms."
				if (( $ERRORS > 1 ));then
					REPORT="$REPORT $ERRORS errors"
				elif (( $ERRORS > 0 ));then
					REPORT="$REPORT $ERRORS error"
				fi
				echo $REPORT > stats.txt
				THEN=$NOW
			fi
		fi
		
		echo -e -n "\\r "
		echo -n ${spinner:$i:1}
		echo -n " $REPORT   "
		
		sleep $interval
	done
else
	echo 'Please specify number of clients to simulate.'
fi

