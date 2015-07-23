#!/bin/bash
#
#author : ftlynx
#Time : 2014-05-30

# 1 mysql up
# 0 mysql down

ConfigFile="`dirname $0`/config.ini"
User=`awk -F '=' '/^MysqlUser/ {print $2}' $ConfigFile`
Host=`awk -F '=' '/^MysqlHost/ {print $2}' $ConfigFile`
Port=`awk -F '=' '/^MysqlPort/ {print $2}' $ConfigFile`
Password=`awk -F '=' '/^MysqlPassword/ {print $2}' $ConfigFile`

if [ -z "$1" ];then
	mysqladmin -u $User -h "$Host" -p"$Password" -P $Port ping | grep -c live
else
	mysqladmin -u $User -h "$Host" -p"$Password" -P $Port extended-status | grep -w $1 | awk -F '|' '{print $3}' | awk '{print $1}'
fi
