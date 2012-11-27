# role/analytics.pp
# Role classes for Analytics and Kraken services.
#
# This file contains base classes and final includable classes.
# The includable role classes are:
#
#   role::analytics::public           - Machines with public facing IP addresses act as proxies to backend services.
#   role::analytics::frontend         - Front end Kraken interfaces (hue, oozie, etc.)
#   role::analytics::hadoop::master   - Hadoop master services (namenode, resourcemanager, jobhistory, etc.)
#   role::analytics::hadoop::worker   - Hadoop worker services (datanode, nodemanager)
#   role::analytics::kafka            - Kafka Broker
#   role::analytics::zookeeper        - Zookeeper Server
#   role::analytics::storm::master    - Storm Nimubs Server
#   role::analytics::storm::worker    - Storm Supervisor Server
#

class role::analytics::public inherits role::analytics {
	include analytics::proxy
	include analytics::misc::web::index
}

class role::analytics::frontend inherits role::analytics {
	include analytics::misc::web::index

	# Oozie server
	include analytics::oozie::server
	# Hive metastore and hive server
	include analytics::hive::server
	# Hue server
	include analytics::hue
}


class role::analytics::hadoop::master inherits role::analytics::hadoop {
	# hadoop master (namenode, etc.)
	include cdh4::hadoop::master

	# Hadoop namenode web interface is missing a css file.
	# Put it in the proper place.
	# See: https://issues.apache.org/jira/browse/HDFS-3578
	file { "/usr/lib/hadoop-hdfs/webapps/static":
		ensure  => "directory",
		require => Class["cdh4::hadoop::master"],
	}
	file { "/usr/lib/hadoop-hdfs/webapps/static/hadoop.css":
		source  => "file:///usr/lib/hadoop-0.20-mapreduce/webapps/static/hadoop.css",
		require => File["/usr/lib/hadoop-hdfs/webapps/static"],
	}
}


class role::analytics::hadoop::worker inherits role::analytics::hadoop {
	# hadoop worker (datanode, etc.)
	include cdh4::hadoop::worker
}


class role::analytics::kafka inherits role::analytics {
	include analytics::kafka::server
}

class role::analytics::zookeeper inherits role::analytics {
	# zookeeper server
	include analytics::zookeeper::server
}

# Storm roles
class role::analytics::storm::master inherits role::analytics {
	# need to fully qualify class name since it matches
	# the role name.
	include ::analytics::storm::master
	# Storm UI server
	include ::analytics::storm::frontend
}
class role::analytics::storm::worker inherits role::analytics {
	# need to fully qualify class name since it matches
	# the role name.
	include ::analytics::storm::worker
}

# == Base Role Classes ==

class role::analytics {
	# TODO, remove apt_source when we go to production
	include analytics_temp
	include cdh4::apt_source

	# install common cdh4 packages and config
	class { "cdh4":
		require => Class["cdh4::apt_source"],
	}

	# zookeeper config is common to all nodes
	class { "analytics::zookeeper::config":
		require => Class["cdh4::apt_source"]
	}

	# hadoop config is common to all nodes
	class { "analytics::hadoop::config":
		require => Class["cdh4::apt_source"],
	}
	# 
	# # kafka client and config is common to all nodes
	# class { "analytics::kafka::client":
	# 	require => File["/etc/apt/sources.list.d/kraken.list"],
	# }
 
	#
	# # storm client and config is common to all nodes
	# class { "analytics::storm::client":
	# 	require => File["/etc/apt/sources.list.d/kraken.list"],
	# }
}

class role::analytics::hadoop inherits role::analytics {
	# hadoop metrics is common to all hadoop nodes
	class { "analytics::hadoop::metrics":
		require => Class["analytics::hadoop::config"],
	}
}


