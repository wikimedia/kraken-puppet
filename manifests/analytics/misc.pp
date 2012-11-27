# == Class analytics::misc::web::index
#
class analytics::misc::web::index {
	require analytics::hadoop::config, analytics::storm
	
	$frontend_hostname = "analytics1027.eqiad.wmnet"
	$namenode_hostname = $analytics::hadoop::config::namenode_hostnamename
	$storm_hostname    = $analytics::storm::nimbus_hostname
	$storm_port        = $analytics::storm::ui_port
	
	file { "/var/www/index.php":
		content => template("index.php.erb"),
	}
}