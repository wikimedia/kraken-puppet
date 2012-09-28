
node analytics_basenode {
	include analytics_temp

	# analytics nodes don't have access to internet.  
	# set this proxy as default for testing.
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
}

# install CDH4 on 20 nodes:
# analytics1002-1022
node /^analytics10(0[2-9]|1[0-9]|2[0-2])/ inherits analytics_basenode {
	# TODO, remove apt_source when we go to production
	class { "cdh::apt_source": version => 'cdh4' }
	class { "cdh": require => Class["cdh::apt_source"] }
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