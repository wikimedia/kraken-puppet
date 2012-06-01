# Class: analytics::base
#
#
class analytics::base {
	include analytics::cloudera
	include analytics::datastax
}