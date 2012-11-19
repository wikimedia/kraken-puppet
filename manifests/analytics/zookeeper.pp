class analytics::zookeeper::config {
	include cdh4::zookeeper
	
	$zookeeper_hosts = [
		"analytics1023.eqiad.wmnet",
		"analytics1024.eqiad.wmnet",
		"analytics1025.eqiad.wmnet"
	]

	class { "cdh4::zookeeper::config":
		zookeeper_hosts => $zookeeper_hosts,
		require         => Class["cdh4::zookeeper"],
	}
}


class analytics::zookeeper::server  {
	include analytics::zookeeper::config

	class { "cdh4::zookeeper::server":
		require => Class["analytics::zookeeper::config"]
	}
}
