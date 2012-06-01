# Class: analytics::cloudera
#
# Sets up Cloudera Hadoop for Wikimedia Analytics Cluster
class analytics::cloudera {
	# install CDH packages
	include cdh
}