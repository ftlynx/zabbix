#!/bin/bash
#
#author : ftlynx
#Time : 2014-05-30

# 1 mysql up
# 0 mysql down

# $1=host
# $2=port
# $3=key

Host=$1
Port=$2

ConfigFile="`dirname $0`/discover.ini"
User=`awk -v h=$Host '/^mysql/ {if($2==h) print $0}' $ConfigFile | awk -v p=$Port '{if($3==p) print $4}'`
Password=`awk -v h=$Host '/^mysql/ {if($2==h) print $0}' $ConfigFile | awk -v p=$Port '{if($3==p) print $5}'`

if [ -z "$3" ];then
	mysqladmin -u $User -h "$Host" -p"$Password" -P $Port ping | grep -c live
else
	mysqladmin -u $User -h "$Host" -p"$Password" -P $Port extended-status | grep -w $3 | awk -F '|' '{print $3}' | awk '{print $1}'
fi
