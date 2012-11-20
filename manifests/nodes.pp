

node analytics1001 {
	include role::analytics::public
}

# analytics1010 is Hadoop Master (i.e NameNode, JobTracker, and ResourceManager)
node analytics1010 {
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
	include role::analytics::hadoop::master
}


# analytics1011-1020
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

# front end hadoop interfaces (hue, oozie, etc.)
node analytics1027 {
	include role::analytics::frontend
}