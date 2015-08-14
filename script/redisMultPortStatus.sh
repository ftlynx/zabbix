#!/bin/bash
#
# total_commands_processed 
# used_memory_rss      系统分配给redis的内存（B）* 1024  = top RES
#

ConfigFile="`dirname $0`/discover.ini"
host=$1
port=$2
auth=`awk -v p=$port '/^redis/ {if($3==p) print $0}' $ConfigFile | awk -v h=$host '{if($2==h) print $4}'`

case $3 in 
	"max_memory")
		out=`redis-cli -a $auth -h $host -p $port CONFIG GET maxmemory | tail -n 1`
		;;
	"total_commands_processed")
		out=`redis-cli -a $auth -h $host -p $port info | grep "total_commands_processed" |awk -F ':' '{print $2}'`
		;;
	"used_memory")
		out=`redis-cli -a $auth -h $host -p $port info | grep "used_memory_rss" |awk -F ':' '{print $2}' | sed 's#\r##g'` 
		;;
	*)
		out=0
		;;
esac
echo $out
