# Class: analytics::cloudera
#
# apt sources for installing analytics packages
class analytics::repositories {
	include analytics::repositories::cloudera
}

# need this so that the cdh module can install cloudera packages.
class analytics::repositories::cloudera($version = 'cdh3') {
	file { "/etc/apt/sources.list.d/cloudera.list":
			content => "deb http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\ndeb-src http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\n",
			mode    => 0444,
			notify  => Exec["/usr/bin/apt-get update"],
			ensure  => 'present',
	}
	
	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/debian/archive.key | /usr/bin/apt-key add -",
		require   => Package["curl"],
		subscribe => File["/etc/apt/sources.list.d/cloudera.list"],
	}

}