


node /^analytics\d+/ {
	include misc_production
	
	class { "analytics": require => Class["misc_production"] }
}