
# == Class cdh4::hadoop
#
# Ensures that hadoop client packages are installed.
# All hadoop nodes require this class. 
class cdh4::hadoop {
  include cdh4::hadoop::install::client
}

# == Class cdh4::hadoop::master
#
# The Hadoop Master is the namenode, jobtracker (MRv1) and resource manager, proxy server and history server (YARN)
class cdh4::hadoop::master inherits cdh4::hadoop {
	include cdh4::hadoop::service::namenode,
		cdh4::hadoop::service::resourcemanager,
		cdh4::hadoop::service::historyserver,
		
		# TODO:  Do we need this on master?
		# cdh4::hadoop::service::proxyserver
}


# == Class cdh4::hadoop::slave
#
# The Hadoop Master is the datanode, tasktracker (MRv1) and node manager (YARN)

class cdh4::hadoop::slave($mapreduce_framework_name = 'yarn') inherits cdh4::hadoop {
	include cdh4::hadoop::service::datanode,
		cdh4::hadoop::service::nodemanager
}