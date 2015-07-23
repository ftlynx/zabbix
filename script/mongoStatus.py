#!/bin/env python
#
#Time   : 2014-12-19
#Author : ftlynx

###### key #########
#mem.resident  (unit: MB)
#network.bytesIn  network.bytesOut
#opcounters.query opcounters.insert opcounters.update. opcounters.delete

import sys
import os
import ConfigParser
import pymongo

def MongoServerStatus(host='127.0.0.1', port=27017):
	try:
		conn=pymongo.MongoClient(host, port)
		data=conn.admin.command('serverStatus')
		conn.close()
	except Exception, e:
		print 0
		exit(2)
	return data

def KeyValue(data, key):
	key=key.split('.')
	for i in key:
		try:
			data=data[i]
		except Exception:
			print 0
			exit(2)
	print data
		
if __name__ == '__main__':
	ConfigFile=os.path.dirname(sys.argv[0])+'/config.ini'
	cf=ConfigParser.ConfigParser()
	cf.read(ConfigFile)
	Host=cf.get("mongo", "MongoHost")
	Port=cf.getint("mongo", "MongoPort")
	KeyValue(MongoServerStatus(host=Host, port=Port), sys.argv[1])
