#!/bin/bash
#
#Author : ftlynx
#Time	: 2014-08-04

discoverFile="`dirname $0`/discover.ini"

discover(){
	i=0
	while read line
	do
		r=`echo "$line" | grep -c '^mysql'`
		if [ $r -eq 0 ];then
			continue
		fi
		name[$i]=`echo $line | awk '{print $1$3}'`
		host[$i]=`echo $line | awk '{print $2}'`		
		port[$i]=`echo $line | awk '{print $3}'`		
		let i++
	done <  $discoverFile
}

zabbix_format(){
	printf '{\n'
	printf '\t"data":[\n'	
	for((i=0;i<${#name[@]};i++))
	do
		printf '\t\t{\n'
		echo -ne "\t\t\t\"{#NAME}\":\"${name[$i]}\",\n"
		echo -ne "\t\t\t\"{#HOST}\":\"${host[$i]}\",\n"
		echo -ne "\t\t\t\"{#PORT}\":${port[$i]}\n"
		if [ $i -eq $((${#name[@]}-1)) ];then
			printf '\t\t}\n'
		else
			printf '\t\t},\n'
		fi
	done
	printf '\t]\n'
	printf '}\n'

}

discover
zabbix_format
