class analytics::zookeeper::config {
	$zookeeper_hosts = [
		"analytics1023.eqiad.wmnet",
		"analytics1024.eqiad.wmnet",
		"analytics1025.eqiad.wmnet"
	]

	class { "cdh4::zookeeper::config":
		zookeeper_hosts => $zookeeper_hosts,
	}
}


class analytics::zookeeper::server {
	require analytics::zookeeper::config
	include cdh4::zookeeper::server
}
