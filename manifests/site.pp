import "nodes.pp"


# analytics nodes don't have access to internet.  
# set this proxy as default for testing.
Exec { environment => 'http_proxy=http://brewster.wikimedia.org:8080' }

# this class does things that ops production
# usually does, or that we will not need
# in production when we are finished with testing.
class analytics_temp {
	# Make sure puppet runs apt-get update!
	exec { "/usr/bin/apt-get update":
		timeout => 240,
		returns => [ 0, 100 ],
	}

	package { ["curl", "dstat"]: ensure => "installed" }

	file { "/etc/profile.d/analytics.sh":
		content => 'export http_proxy="http://brewster.wikimedia.org:8080"

alias pupup="pushd .; cd /etc/puppet.analytics && sudo git pull; popd"
alias puptest="sudo puppetd --test --verbose --server analytics1001.wikimedia.org --vardir /var/lib/puppet.analytics --ssldir /var/lib/puppet.analytics/ssl --confdir=/etc/puppet.analytics"
alias pupsign="sudo puppetca --vardir /var/lib/puppet.analytics --ssldir /var/lib/puppet.analytics/ssl --confdir=/etc/puppet.analytics sign "',
		mode => 755,
	}
}