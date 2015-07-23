#!/bin/bash
#
#Author : ftlynx
#Time   : 2014-08-01

ConfigFile="`dirname $0`/config.ini"
url=`awk -F '=' '/^NgxUrl/ {print $2}' $ConfigFile`

result=`curl -s -i "$url"`
httpstatus=`echo "$result" | sed -n '1p' |awk '{print $2}'`
if [ "$httpstatus" != "200" ];then
	echo "0"
	exit 1
fi

nginx_handle=`echo "$result" | grep -A 1 "server accepts handled requests" |sed -n '2p'`
nginx_connections=`echo "$result" | grep '^Reading'`

case $1 in
	"accepts")
		echo "$nginx_handle" | awk '{print $1}'
		;;
	"handled")
		echo "$nginx_handle" | awk '{print $2}'
		;;
	"requests")
		echo "$nginx_handle"| awk '{print $3}'
		;;
	"Reading")
		echo "$nginx_connections" | awk '{print $2}'
		;;
	"Writing")
		echo "$nginx_connections" | awk '{print $4}'
		;;
	"Waiting")
		echo "$nginx_connections" | awk '{print $6}'
		;;
	*)
		echo 0
		;;
esac
