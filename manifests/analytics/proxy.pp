# == Class analytics::proxy
# Uses haproxy to set up a proxy to
# internally hosted web services.
#
class analytics::proxy {
	$namenode_hostname = $analytics::hadoop::config::namenode_hostname
	$frontend_hostname = "analytics1027.eqiad.wmnet"
	$hue_hostname      = $frontend_hostname
	$oozie_hostname    = $frontend_hostname

	package { "haproxy": ensure => "installed" }

	file { "/etc/haproxy/haproxy.cfg":
		content => template("haproxy.cfg.erb"),
		require => Package["haproxy"],
	}
	
	service { "haproxy":
		ensure    => running,
		enabled   => true,
		subscribe => File["/etc/haproxy/haproxy.cfg"],
	}
}
