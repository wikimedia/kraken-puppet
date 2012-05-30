


node /^analytics\d+/ {
	include analytics_temp
	
	class { "analytics": require => Class["misc_production"] }
}