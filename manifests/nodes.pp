


node /^analytics\d+/ {
	include analytics_temp
	
	class { "analytics": require => Class["analytics_temp"] }
}