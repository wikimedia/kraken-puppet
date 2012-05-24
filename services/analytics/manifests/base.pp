# Class: analytics::base
#
#
class analytics::base {
	class { "analytics::repositories": }
	class { "cdh": require => Class["analytics::repositories"] }
}