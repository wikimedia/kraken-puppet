# Class: analytics::cloudera
#
# Sets up Cloudera Hadoop for Wikimedia Analytics Cluster
class analytics::cloudera {
	# install CDH packages
	include analytics::cloudera::apt_source	
	# include dse class from dse module.  This installs DSE packages
	class { "cdh": require => Class["analytics::cloudera::apt_source"] }
	
	include analytics::cloudera::hadoop
}

# Class: analytics::cloudera::hadoop
#
# TODO: puppetize the directory creation
class analytics::cloudera::hadoop {
	$namenode_hostname        = "analytics1001.wikimedia.org"
	$hadoop_name_directory    = "/var/lib/hadoop-0.20/name"
	$hadoop_data_directory    = "/var/lib/hadoop-0.20/data"
	$hadoop_hdfs_data_path    = "hdfs/dn"
	$hadoop_mapred_local_path = "mapred/local"

	class { "cdh::hadoop::config":
		namenode_hostname => $namenode_hostname,
		dfs_name_dir  => [$hadoop_name_directory],
		dfs_data_dir  => [
			"$hadoop_data_directory/e/$hadoop_hdfs_data_path",
			"$hadoop_data_directory/f/$hadoop_hdfs_data_path",
			"$hadoop_data_directory/g/$hadoop_hdfs_data_path",
			"$hadoop_data_directory/h/$hadoop_hdfs_data_path",
			"$hadoop_data_directory/i/$hadoop_hdfs_data_path",
			"$hadoop_data_directory/j/$hadoop_hdfs_data_path",
		],
		mapred_local_dir  => [
			"$hadoop_data_directory/e/$hadoop_mapred_local_path",
			"$hadoop_data_directory/f/$hadoop_mapred_local_path",
			"$hadoop_data_directory/g/$hadoop_mapred_local_path",
			"$hadoop_data_directory/h/$hadoop_mapred_local_path",
			"$hadoop_data_directory/i/$hadoop_mapred_local_path",
			"$hadoop_data_directory/j/$hadoop_mapred_local_path",
		],
		dfs_block_size => "134217728",   # 128MB for testing
	}
}


class analytics::cloudera::master {
	require analytics::cloudera

	include 
		cdh::hadoop::service::namenode,
		cdh::hadoop::service::jobtracker
}

class analytics::cloudera::slave {
	require analytics::cloudera

	include 
		cdh::hadoop::service::datanode,
		cdh::hadoop::service::tasktracker
}



class analytics::cloudera::apt_source($version = 'cdh3') {
	file { "/etc/apt/sources.list.d/cloudera.list":
		content => "deb http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\ndeb-src http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\n",
		mode    => 0444,
		ensure  => 'present',
	}
	
	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/debian/archive.key | /usr/bin/apt-key add -",
		require   => Package["curl"],
		subscribe => File["/etc/apt/sources.list.d/cloudera.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
	}
	
	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cloudera.list"], Exec["import_cloudera_apt_key"]],
	}
}
