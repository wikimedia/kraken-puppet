
node analytics_basenode {
	include analytics_temp
}


# analytics1001 is master node (namenode & jobtracker)
node analytics1001 inherits analytics_basenode {
	class { "analytics::master": require => Class["analytics_temp"] }
}

# all other nodes are slave nodes (datanode & tasktracker)
node /^analytics10(0[2-9]|10)/ inherits analytics_basenode {
	class { "analytics::slave": require => Class["analytics_temp"] }

	# analytics nodes don't have access to internet.  
	# set this proxy as default for testing.
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
}