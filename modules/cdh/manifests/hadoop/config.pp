# Class: cdh::hadoop::config
#
# Installs some Hadoop/HDFS config files.
# This assumes that the mapred_directories
# should be inside of the data_directories.
class cdh::hadoop::config(	
	$name_directories,
	$data_directories,
	$config_directory   = '/etc/hadoop/conf') {
	
	require cdh::hadoop
	
	file { "$config_directory/hdfs-site.xml":
		content => template("cdh/hadoop/hdfs-site.xml.erb")
	}

	file { "$config_directory/mapred-site.xml":
		content => template("cdh/hadoop/mapred-site.xml.erb")
	}
}

