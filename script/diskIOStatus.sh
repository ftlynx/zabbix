#!/bin/bash
#
#Author	: ftlynx
#Time	: 214-08-11

sfile=/proc/diskstats

zabbix_format(){
	dev_name=(`cat /proc/partitions | awk '{print $NF}' | grep -v '^$' | grep -v 'name'`)
	printf '{\n'
        printf '\t"data":[\n'
        for((i=0;i<${#dev_name[@]};i++))
        do
                printf '\t\t{\n'
                echo -ne "\t\t\t\"{#DEV_NAME}\":\"${dev_name[$i]}\"\n"
                if [ $i -eq $((${#dev_name[@]}-1)) ];then
                        printf '\t\t}\n'
                else
                        printf '\t\t},\n'
                fi
        done
        printf '\t]\n'
        printf '}\n'
}

reads(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $4}' $sfile`
	echo $result
}

read_merge(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $5}' $sfile`
	echo $result
}

read_sec(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $6}' $sfile`
	echo $result
}

writes(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $8}' $sfile`
	echo $result
}

write_merge(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $9}' $sfile`
	echo $result
}

write_sec(){
	dev=$1
	result=`awk -v name=$dev '{if($3==name) print $10}' $sfile`
	echo $result
}



if [ -z "$1" ];then
	zabbix_format
	exit 0
fi

case $2 in 
	"readsec")
		read_sec $1
		;;
	"writesec")
		write_sec $1 
		;;
	"reads")
		reads $1
		;;
	"writes")
		writes $1
		;;
	"readmerge")
		read_merge $1
		;;
	"writemerge")
		write_merge $1
		;;
	*)
		echo "0"
		;;
esac
