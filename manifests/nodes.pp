
# an01 was previous hadoop master.
# Namenode has moved to an10, but extra service remain for now.
node analytics1001 {
	include role::analytics::temp::extra_services
}

# analytics1010 is Hadoop Master (i.e NameNode, JobTracker, and ResourceManager)
node analytics1010 {
	# include role::analytics::master
	include role::analytics::temp::namenode
}


# # analytics1002-1009
# node /^analytics10(0[2-9])/ {
# 	# analytics nodes don't have access to internet.  
# 	# set this proxy as default for testing.
# 	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
# 	
# 	# $hadoop_data_directory    = "/var/lib/hadoop/data"
# 	# class { "role::analytics::worker": 
# 	# 	datanode_mounts => [
# 	# 		"$hadoop_data_directory/e",
# 	# 		"$hadoop_data_directory/f",
# 	# 		"$hadoop_data_directory/g",
# 	# 		"$hadoop_data_directory/h",
# 	# 		"$hadoop_data_directory/i",
# 	# 		"$hadoop_data_directory/j",
# 	# 	],
# 	# }
# }

# analytics1011-1020
node /^analytics10(1[1-9]|20)/ {
	# analytics nodes don't have access to internet.  
	# set this proxy as default for testing.
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
	
	$hadoop_data_directory    = "/var/lib/hadoop/data"
	class { "role::analytics::worker": 
		datanode_mounts => [
			"$hadoop_data_directory/c",
			"$hadoop_data_directory/d",
			"$hadoop_data_directory/e",
			"$hadoop_data_directory/f",
			"$hadoop_data_directory/g",
			"$hadoop_data_directory/h",
			"$hadoop_data_directory/i",
			"$hadoop_data_directory/j",
			"$hadoop_data_directory/k",
			"$hadoop_data_directory/l",
		],
	}
}

# analytics1021 and analytics1022 are Kafka Brokers
node analytics1021, analytics1022 {
	include role::analytics::kafka
}

# analytics1023, analytics1024 and anlytics1025 are Zookeeper Servers
node analytics1023,analytics1024,analytics1025 {
	include role::analytics::zookeeper
}









# # cassandra nodes
# node /^analytics10(0[2-9]|10|18)/ inherits analytics_basenode {
# 	# install Datastax Enterprise Cassandra Hadoop
# 	include dse
# 
# 	$cassandra_cluster_name = "KrakenAnalytics"
# 
# 	$cassandra_seeds = [
# 		"10.64.21.103",   # an03
# 		"10.64.21.104",   # an04
# 	]
# 
# 	$cassandra_data_file_directories = [
# 		"/var/lib/cassandra/data/f",
# 		"/var/lib/cassandra/data/g",
# 		"/var/lib/cassandra/data/h",
# 		"/var/lib/cassandra/data/i",
# 		"/var/lib/cassandra/data/j"
# 	]
# 
# 	# configure cassandra.
# 	class { "dse::cassandra::server":
# 		cluster_name          => $cassandra_cluster_name,
# 		seeds                 => $cassandra_seeds,
# 		data_file_directories => $cassandra_data_file_directories,
# 	}
# }


# # analytics1001 is master node (namenode & jobtracker)
# node analytics1001 inherits analytics_basenode {
# 	class { "analytics::master": require => Class["analytics_temp"] }
# }
# 
# # all other nodes are slave nodes (datanode & tasktracker)
# node /^analytics10(0[2-9]|10)/ inherits analytics_basenode {
# 	class { "analytics::slave": require => Class["analytics_temp"] }
# 
# 	# analytics nodes don't have access to internet.  
# 	# set this proxy as default for testing.
# 	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
# }