# analytics/packages.pp
# Place for common package dependencies.

class analytics::packages::mysql_java {
	package { "libmysql-java":
		ensure => installed,
	}	
}
