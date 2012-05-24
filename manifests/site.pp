import "nodes.pp"


# this class does things that ops production
# usually does.
class misc_production {
	# Make sure puppet runs apt-get update!
	exec { "/usr/bin/apt-get update":
		timeout => 240,
		returns => [ 0, 100 ];
	}
	
	package { "curl": ensure => "installed" }
	
	Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }
}