# Class: dse
#
#
class dse {
	include packages
}


# Class: dse::packages
#
#
class dse::packages {
	require repository
	
	package { ["dse-full", "opscenter", "libjna-java"]:
		ensure => "installed",
	}
	
	# # http://www.datastax.com/docs/datastax_enterprise2.0/install_dse_packages#install-deb-pkg
	# # says that we need to update to JNA 3.4 manually
	# exec { "download_jna_3.4_jar":
	# 	command => "/usr/bin/wget -P /usr/share/java https://github.com/downloads/twall/jna/jna.jar"
	# }
}