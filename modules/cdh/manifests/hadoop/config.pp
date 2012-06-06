# Class: cdh::hadoop::config
#
# Installs some Hadoop/HDFS config files.
# This assumes that the mapred_directories
# should be inside of the data_directories.
class cdh::hadoop::config(
	$dfs_name_dir,
	$dfs_data_dir,
	$mapred_local_dir,
	$namenode_hostname,
	$namenode_port = '8020',
	$config_directory   = '/etc/hadoop/conf') {
	
	require cdh::hadoop
	
	file { "$config_directory/core-site.xml":
		content => template("cdh/hadoop/core-site.xml.erb")
	}
	
	file { "$config_directory/hdfs-site.xml":
		content => template("cdh/hadoop/hdfs-site.xml.erb")
	}

	file { "$config_directory/mapred-site.xml":
		content => template("cdh/hadoop/mapred-site.xml.erb")
	}
}
