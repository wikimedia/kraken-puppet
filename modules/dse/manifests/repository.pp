class dse::repository {
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