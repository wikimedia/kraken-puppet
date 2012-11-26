
# analytics1001 is currently the only
# Analytics node with a public IP.
node analytics1001 {
	include role::analytics::public
}

# analytics1002 is Storm Master (i.e. Storm Nimbus server)
node analytics1002 {
	include role::analytics::storm::master
}

# analytics1003 - analytics1009 are Storm Workers (i.e. Storm Supervisor servers)
node /^analytics100[3-9]/ {
	include role::analytics::storm::worker
}

# analytics1010 is Hadoop Master (i.e NameNode, JobTracker, and ResourceManager)
node analytics1010 {
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
	include role::analytics::hadoop::master
}


# analytics1011-1020 are Hadoop Workers (i.e. NodeManager, DataNode)
node /^analytics10(1[1-9]|20)/ {
	# analytics nodes don't have access to internet.  
	# set this proxy as default for testing.
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
	include role::analytics::hadoop::worker
}

# analytics1021 and analytics1022 are Kafka Brokers
node analytics1021, analytics1022 {
	include role::analytics::kafka
}

# analytics1023, analytics1024 and anlytics1025 are Zookeeper Servers
node analytics1023,analytics1024,analytics1025 {
	include role::analytics::zookeeper
}

# front end web interfaces (Hue, Oozie, Storm UI, etc.)
node analytics1027 {
	include role::analytics::frontend
}