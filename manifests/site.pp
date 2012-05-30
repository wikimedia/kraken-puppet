import "nodes.pp"


# analytics nodes don't have access to internet.  
# set this proxy as default for testing.
Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }

# this class does things that ops production
# usually does.
class misc_production {
	# Make sure puppet runs apt-get update!
	exec { "/usr/bin/apt-get update":
		timeout => 240,
		returns => [ 0, 100 ],
	}

	package { "curl": ensure => "installed" }
	
}