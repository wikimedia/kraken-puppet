# Class: analytics::cloudera
#
# Sets up Cloudera Hadoop for Wikimedia Analytics Cluster
class analytics::cloudera {
	# install CDH packages
	include analytics::cloudera::apt_source	
	# include dse class from dse module.  This installs DSE packages
	class { "cdh": require => Class["analytics::cloudera::apt_source"] }
}

class analytics::cloudera::apt_source {
	file { "/etc/apt/sources.list.d/cloudera.list":
		content => "deb http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\ndeb-src http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\n",
		mode    => 0444,
		ensure  => 'present',
	}
	
	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/debian/archive.key | /usr/bin/apt-key add -",
		require   => Package["curl"],
		subscribe => File["/etc/apt/sources.list.d/cloudera.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
	}
	
	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cloudera.list"], Exec["import_cloudera_apt_key"]],
	}
}
