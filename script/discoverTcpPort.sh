#!/bin/bash
#
#Author : ftlynx
#Time	: 2014-08-04
#Requirement:
#	  1. Please install sudo(yum install sudo)
#	  2. execute 'visudo' command. add "zabbix ALL=(root) NOPASSWD: /bin/netstat"
#	  3. execute 'visudo' command. modify "Defaults requiretty" to "Defaults:zabbix !requiretty"

discover(){
	data=`sudo netstat -lntp | grep '^tcp' | grep -v '127.0.0.1' | grep -v ':::'`
	service_name=(`echo "$data" | awk -F '/' '{print $NF}' | awk '{print $1}' | sort`)
	for((i=0;i<${#service_name[@]};))
	do
		ports=`echo "$data" | grep ${service_name[$i]} | awk '{print $4}' | awk -F ':' '{print $2}'`
		for port in `echo "$ports"`
		do
			service_name[$i]="${service_name[$i]}-$port"
			service_port[$i]=$port
			let i++
		done
	done
}

zabbix_format(){
	printf '{\n'
	printf '\t"data":[\n'	
	for((i=0;i<${#service_name[@]};i++))
	do
		printf '\t\t{\n'
		echo -ne "\t\t\t\"{#SERVICE_NAME}\":\"${service_name[$i]}\",\n"
		echo -ne "\t\t\t\"{#SERVICE_PORT}\":${service_port[$i]}\n"
		if [ $i -eq $((${#service_name[@]}-1)) ];then
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
