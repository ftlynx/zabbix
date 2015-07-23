#!/bin/bash
#
#Author	: ftlynx
#Time	: 2014-11-24
#	accepted = "accepted conn"
#	idle	= "idle processes"
#	total	= "total processes"
#	active	= "active processes"

ConfigFile="`dirname $0`/config.ini"
url=`awk -F '=' '/^phpfpmUrl/ {print $2}' $ConfigFile`

html=`curl -s -i "$url"`
httpstatus=`echo "$html" | sed -n '1p' |awk '{print $2}'`
if [ "$httpstatus" != "200" ];then
        echo 0
        exit 1
fi

case "$1" in
	"accepted")
		r=`echo "$html" | grep "^accepted"  | awk '{print $NF}'`
		;;
	"total")
		r=`echo "$html" | grep "^tota"  | awk '{print $NF}'`
		;;
	"active")
		r=`echo "$html" | grep "^active" | awk '{print $NF}'`
		;;
	"idle")
		r=`echo "$html" | grep "^idle" | awk '{print $NF}'`
		;;
	*)
		r=0
		;;
esac	
echo $r
