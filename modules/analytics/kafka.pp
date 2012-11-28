class analytics::kafka {
	require analytics::zookeeper::config
	include kafka, kafka::install
	class { "kafka::config":
		zookeeper_hosts => $analytics::zookeeper::config::zookeeper_hosts,
	}
}

class analytics::kafka::server inherits analytics::kafka {
	# kafka broker server
	include kafka::server
	include analytics::monitoring::kafka
}

class analytics::kafka::client inherits analytics::kafka {
	# no need to do anything, all we need
	# are classes from parent class analytics::kafka.
}