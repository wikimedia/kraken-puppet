# Currently these classes
# only install the appropriate CDH4 daemon
# packages in order to start services.
# If we end up using hadoop in production,
# these classes can also ensure that
# the appropriate services are running.


# Class: cdh4::hadoop::service::namenode
class cdh4::hadoop::service::namenode {
	# install namenode daemon package
	package { "hadoop-hdfs-namenode": ensure => installed }
}

# Class: cdh4::hadoop::service::namenode
class cdh4::hadoop::service::secondarynamenode {
	# install secondarynamenode daemon package
	package { "hadoop-hdfs-secondarynamenode": ensure => installed }
}

# Class: cdh4::hadoop::service::datanode
class cdh4::hadoop::service::datanode {
	# install datanode daemon package
	package { "hadoop-hdfs-datanode": ensure => installed }
}

# # Class: cdh4::hadoop::service::jobtracker
# class cdh4::hadoop::service::jobtracker {
# 	require cdh4::hadoop::service::namenode
# 
# 	# install jobtracker daemon package
# 	package { "hadoop-0.20-mapreduce-jobtracker": ensure => installed }
# }
# 
# # Class: cdh4::hadoop::service::tasktracker
# class cdh4::hadoop::service::tasktracker {
# 	require cdh4::hadoop::service::datanode
# 	
# 	# install tasktracker daemon package
# 	package { "hadoop-0.20-mapreduce-tasktracker": ensure => installed }
# }



# YARN packages and services

# Class: cdh4::hadoop::service::resourcemanager
# (Analagous to JobTracker)
class cdh4::hadoop::service::resourcemanager {
	require cdh4::hadoop::service::namenode

	# install resourcemanager daemon package
	package { "hadoop-yarn-resourcemanager": ensure => installed }
}


# Class: cdh4::hadoop::service::nodemanager
# (Analagous to TaskTracker)
class cdh4::hadoop::service::nodemanager {
	# nodemanagers are also datanodes
	require cdh4::hadoop::service::datanode

	# install nodemanager and mapreduce (YARN) daemon package
	package { ["hadoop-yarn-nodemanager", "hadoop-mapreduce"]: ensure => installed }
}

# Class: cdh4::hadoop::service::historyserver
class cdh4::hadoop::service::historyserver {
	# install historyserver daemon package
	package { "hadoop-mapreduce-historyserver": ensure => installed }
}

# Class: cdh4::hadoop::service::proxyserver
class cdh4::hadoop::service::proxyserver {
	# install proxyserver daemon package
	package { "hadoop-yarn-proxyserver": ensure => installed }
}
