# Class: cdh4::hadoop::config
#
# Installs some Hadoop/HDFS config files.
# This assumes that the mapred_directories
# should be inside of the data_directories.
class cdh4::hadoop::config(
	$mounts,
	$dfs_name_dir,
	$namenode_hostname,
	$config_directory                 = '/etc/hadoop/conf',
	$dfs_block_size                   = 67108864, # 64MB default
	$yarn_local_path = "yarn/local",
	$yarn_logs_path  = "yarn/logs",
	$data_path       = "hdfs/dn",
	) {

	require cdh4::hadoop

	# TODO: set default map/reduce tasks
	# automatically based on node stats.
	file { "$config_directory/core-site.xml":
		content => template("cdh4/hadoop/core-site.xml.erb")
	}

	file { "$config_directory/hdfs-site.xml":
		content => template("cdh4/hadoop/hdfs-site.xml.erb")
	}

	file { "$config_directory/yarn-site.xml":
		content => template("cdh4/hadoop/yarn-site.xml.erb")
	}

	# only need this to set framework.name
	file { "$config_directory/mapred-site.xml":
		content => template("cdh4/hadoop/mapred-site.xml.erb")
	}
}
