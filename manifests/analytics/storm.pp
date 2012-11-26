# == Class analytics::storm::master
#
# Inherits from analytics::storm to get installtion and config,
# and then configures a Storm Nimbus server and ensures that it is running.
class analytics::storm::master inherits analytics::storm {
  include storm::nimbus
}

# == Class analytics::storm::worker
#
# Inherits from analytics::storm to get installtion and config,
# and then configures a Storm Supervisor server and ensures that it is running.
class analytics::storm::worker inherits analytics::storm {
  include storm::supervisor
}

# == Class analytics::storm::ui
#
# Inherits from analytics::storm to get installtion and config,
# and then configures a Storm UI server and ensures that it is running.
class analytics::storm::ui inherits analtyics::storm {
  include storm::ui
}

# == Class analytics::storm::client
#
# Installs Storm, but doesn't start any services.
class analytics::storm::client inherits analytics::storm {
	# no need to do anything, all we need
	# are classes from parent class analytics::storm.
}

# == Class analytics::storm
#
# Installs Storm and generic Storm configs.
class analytics::storm {
	$nimbus_host = "analytics1002.eqiad.wmnet"
	$zookeeper_hosts = $analytics::zookeeper::config::zookeeper_hosts
	class { "storm":
		nimbus_host     => $nimbus_host,
		zookeeper_hosts => $zookeeper_hosts,
		ui_port         => 6999,
		# use all but 2 processors on each supervisor worker machine
		worker_count    => $processorcount - 2,
	}
}
