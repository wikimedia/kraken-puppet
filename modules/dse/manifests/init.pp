# Class: dse
#
#
class dse($type = 'analytics', $cfs_replication_factor = 1) {
	include dse::packages

	# Configure the type of Datastax
	# node this will be.  These variables
	# are rendered into /etc/default/dse
	# and are used to tell the Cassandra
	# instance what type of workload it is
	# supposed to handle.
	case $type {
		'analytics': {
			$hadoop_enabled = true
			$solr_enabled   = false
		}
		'search': {
			$hadoop_enabled = false
			$solr_enabled   = true
		}
		'realtime': {
			$hadoop_enabled = false
			$solr_enabled   = false
		}
	}

	file { "/etc/default/dse":
		content => template("dse/dse.default.erb"),
		require => Class['dse::packages'],
	}
}


# Class: dse::packages
#
#
class dse::packages {
	# TODO.  put packages in our apt repository
	include dse::apt_source

	package { ["dse-full", "opscenter", "libjna-java"]:
		ensure => "installed",
		require => Class["dse::apt_source"],
	}
}

class dse::apt_source {
	# TODO: change these when we go into production.
	$username = "otto_wikimedia.org"
	$password = "LwVPlBpUYzQJLXa"
	
	file { "/etc/apt/sources.list.d/datastax.list":
		content => "deb http://$username:$password@debian.datastax.com/enterprise stable main",
		mode    => 0444,
		ensure  => 'present',
	}
	
	exec { "import_datastax_apt_key":
		command   => "/usr/bin/curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -",
		require   => Package["curl"],
		subscribe => File["/etc/apt/sources.list.d/datastax.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Riptano",  # Riptano == Datastax ???
	}
	
	exec { "apt_get_update_for_datastax":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/datastax.list"], Exec["import_datastax_apt_key"]],
	}
}