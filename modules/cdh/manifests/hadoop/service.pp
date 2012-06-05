# Currently these classes
# only install the appropriate CDH3 daemon
# packages in order to start services.
# If we end up using hadoop in production,
# these classes can also ensure that
# the appropriate services are running.

# Class: cdh::hadoop::service::namenode
#
#
class cdh::hadoop::service::namenode {
	# install namenode daemon package
	package { "hadoop-0.20-namenode": ensure => latest }
}

# Class: cdh::hadoop::service::datanode
#
#
class cdh::hadoop::service::datanode {
	# install datanode daemon package
	package { "hadoop-0.20-datanode": ensure => latest }
}

# Class: cdh::hadoop::service::jobtracker
#
#
class cdh::hadoop::service::jobtracker {
	# install jobtracker daemon package
	package { "hadoop-0.20-jobtracker": ensure => latest }
}

# Class: cdh::hadoop::service::tasktracker
#
#
class cdh::hadoop::service::tasktracker {
	# install tasktracker daemon package
	package { "hadoop-0.20-tasktracker": ensure => latest }
}