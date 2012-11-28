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
	include kraken::proxy
	include kraken::misc::web::index
}

class role::analytics::frontend inherits role::analytics {
	include kraken::misc::web::index

	# Oozie server
	include kraken::oozie::server
	# Hive metastore and hive server
	include kraken::hive::server
	# Hue server
	include kraken::hue
}


class role::analytics::kafka inherits role::analytics {
	include kraken::kafka::server
}

class role::analytics::zookeeper inherits role::analytics {
	# zookeeper server
	include kraken::zookeeper::server
}

# Storm roles
class role::analytics::storm::master inherits role::analytics {
	include kraken::storm::master
	# Storm UI server
	include kraken::storm::frontend
}
class role::analytics::storm::worker inherits role::analytics {
	include kraken::storm::worker
}


# Hadoop roles
class role::analytics::hadoop::master inherits role::analytics::hadoop {
	include kraken::hadoop::master
}

class role::analytics::hadoop::worker inherits role::analytics::hadoop {
	include kraken::hadoop::worker
}

# == Base Role Classes ==

class role::analytics {
	include kraken
}

class role::analytics::hadoop inherits role::analytics {
	# hadoop metrics is common to all hadoop nodes
	class { "kraken::hadoop::metrics":
		require => Class["kraken::hadoop::config"],
	}
}


