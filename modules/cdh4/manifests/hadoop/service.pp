# Currently these classes
# only install the appropriate CDH4 daemon
# packages in order to start services.
# If we end up using hadoop in production,
# these classes can also ensure that
# the appropriate services are running.


class cdh4::hadoop::service::namenode {
	require cdh4::hadoop::install::namenode
	
	service { "hadoop-hdfs-namenode": 
		ensure => "running",
		enable => true,
		alias  => "namenode",
	}
}

class cdh4::hadoop::service::secondarynamenode {
	require cdh4::hadoop::install::secondarynamenode

	service { "hadoop-hdfs-secondarynamenode": 
		ensure => "running",
		enable => true,
		alias  => "secondarynamenode",
	}
}

class cdh4::hadoop::service::datanode {
	require cdh4::hadoop::install::datanode

	# install datanode daemon package
	service { "hadoop-hdfs-datanode": 
		ensure => "running",
		enable => true,
		alias  => "datanode",
	}
}

#
# YARN services
#

class cdh4::hadoop::service::resourcemanager {
	require cdh4::hadoop::install::resourcemanager
	require cdh4::hadoop::service::namenode

	# ResourceManager (YARN JobTracker)
	service { "hadoop-yarn-resourcemanager":
		ensure => "running",
		enable => true,
		alias  => "resourcemanager",
	}
}


class cdh4::hadoop::service::nodemanager {
	# nodemanagers are also datanodes
	require cdh4::hadoop::install::nodemanager
	require cdh4::hadoop::service::datanode

	# NodeManager (YARN TaskTracker)
	service { "hadoop-yarn-nodemanager":
		ensure => "running",
		enable => true,
		alias  => "nodemanager",
	}
}

class cdh4::hadoop::service::historyserver {
	require cdh4::hadoop::install::historyserver

	service { "hadoop-mapreduce-historyserver":
		ensure => "running",
		enable => true,
		alias  => "historyserver",
	}
}

class cdh4::hadoop::service::proxyserver {
	require cdh4::hadoop::install::proxyserver

	# install proxyserver daemon package
	service { "hadoop-yarn-proxyserver":
		ensure => "running",
		enable => true,
		alias  => "proxyserver",
	}
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
