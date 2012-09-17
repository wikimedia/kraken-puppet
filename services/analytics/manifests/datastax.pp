# Class: analytics::datastax
#
# Sets up Datastax Enterprise for Wikimedia Analytics Cluster
class analytics::datastax {
	# install DSE packages
	include analytics::datastax::apt_source
	# include dse class from dse module.  This installs DSE packages
	class { "dse": require => Class["analytics::datastax::apt_source"] }
}

class analytics::datastax::apt_source {
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