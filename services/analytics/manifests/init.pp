# Class: analytics
#
#
class analytics {
	include analytics::cloudera
	include analytics::datastax
}

class analytics::master inherits analytics {
	include analytics::cloudera::master
}

class analytics::slave inherits analytics {
	include analytics::cloudera::slave
}