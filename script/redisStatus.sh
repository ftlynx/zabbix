#!/bin/bash
#
# total_commands_processed 
# used_memory_rss      系统分配给redis的内存（B）* 1024  = top RES
#

ConfigFile="`dirname $0`/config.ini"
host=`awk -F '=' '/^RedisHost/ {print $2}' $ConfigFile`
port=`awk -F '=' '/^RedisPort/ {print $2}' $ConfigFile`

case $1 in 
	"max_memory")
		out=`redis-cli -h $host -p $port CONFIG GET maxmemory | tail -n 1`
		;;
	"total_commands_processed")
		out=`redis-cli -h $host -p $port info | grep "total_commands_processed" |awk -F ':' '{print $2}'`
		;;
	"free_memory")
		max=`redis-cli -h $host -p $port CONFIG GET maxmemory | tail -n 1`
		used=`redis-cli -h $host -p $port info | grep "used_memory_rss" |awk -F ':' '{print $2}' | sed 's#\r##g'` 
		out=$((max - used))
		;;
	*)
		out=0
		;;
esac
echo $out
