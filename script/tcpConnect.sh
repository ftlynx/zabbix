#!/bin/bash
#
#Author	: ftlynx
#Time	: 2015-06-09

case $1 in 
	"Total")
		num=`ss -s | awk '/^TCP:/ {print $2}'`
		;;
	"TIME_WAIT")
		num=`ss -s | awk '/^TCP:/ {print $12}' |awk -F/ '{print $1}'`
		;;
	"SYN_RECV")
		num=`ss -s | awk '/^TCP:/ {print $10}' |awk -F, '{print $1}'`
		;;
	"ESTABLISHED")
		num=`ss -s | awk '/^TCP:/ {print $4}'  |awk -F, '{print $1}'`
		;;
	*)
		num=0
		;;
esac
echo $num
