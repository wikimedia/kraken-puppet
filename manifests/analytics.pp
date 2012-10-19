class role::analytics {
	# TODO, remove apt_source when we go to production
	require cdh4::apt_source
	include analytics_temp

	# install common cdh4 packages and config
	include cdh4 
	# hadoop config is common to all nodes
	include analytics::hadoop::config
}




class role::analytics::master inherits role::analytics {
	# hadoop master (namenode, etc.)
	include cdh4::hadoop::master
	# oozier server
	include analytics::oozie::server
	# hue server
	class { "cdh4::hue":
		# TODO:  Change secret_key and put it in private puppet repo.
		secret_key => "MQBvbk9fk9u1hSr7S13auZyYbRAPK0BbSr6k0NLokTNswv1wNU4v90nUhZE3",
		require    => Class["cdh4::oozie::server"],
	}
}

class role::analytics::worker inherits analytics::base {
	# hadoop worker (datanode, etc.)
	include cdh4::hadoop::worker
}






class analytics::hadoop::config {
	$namenode_hostname        = "analytics1001.wikimedia.org"
	$hadoop_base_directory    = "/var/lib/hadoop"
	$hadoop_name_directory    = "$hadoop_base_directory/name"
	$hadoop_data_directory    = "$hadoop_base_directory/data"
	
	$hadoop_mounts = [
		"$hadoop_data_directory/e",
		"$hadoop_data_directory/f",
		"$hadoop_data_directory/g",
		"$hadoop_data_directory/h",
		"$hadoop_data_directory/i",
		"$hadoop_data_directory/j",
	]

	class { "cdh4::hadoop::config":
		namenode_hostname    => $namenode_hostname,
		mounts               => $hadoop_mounts,
		dfs_name_dir         => [$hadoop_name_directory],
		dfs_block_size       => 268435456,  # 256 MB
		map_tasks_maximum    => ($processorcount - 2) / 2,
		reduce_tasks_maximum => ($processorcount - 2) / 2,
		map_memory_mb        => 1536,
		io_file_buffer_size  => 131072,
		reduce_parallel_copies => 10,
		mapreduce_job_reuse_jvm_num_tasks => -1,
		mapreduce_child_java_opts => "-Xmx512M",
	}
}





class analytics::oozie::server {
	# require analytics::db::mysql

	package { "libmysql-java":
		ensure => installed,
	}

	# symlink the mysql.jar into /var/lib/oozie
	file { "/var/lib/oozie/mysql.jar":
		ensure  => "/usr/share/java/mysql.jar",
		require => Package["libmysql-java"]
	}

	$oozie_db_name    = "oozie"
	$oozie_db_user    = "oozie"
	# TODO: put this in private puppet repo
	$oozie_db_pass    = "oozie"
	# oozie is going to need an oozie database and user.
	exec { "oozie_mysql_create_database":
		command => "/usr/bin/mysql -e \"CREATE DATABASE $oozie_db_name; GRANT ALL PRIVILEGES ON $oozie_db_name.* TO '$oozie_db_user'@'localhost' IDENTIFIED BY '$oozie_db_pass'; GRANT ALL PRIVILEGES ON $oozie_db_name.* TO '$oozie_db_user'@'%' IDENTIFIED BY '$oozie_db_pass';\"",
		unless  => "/usr/bin/mysql -e 'SHOW DATABASES' | /bin/grep -q $oozie_db_name",
		user    => 'root',
	}

	class { "cdh4::oozie::server":
		jdbc_driver       => "com.mysql.jdbc.Driver",
		jdbc_url          => "jdbc:mysql://localhost:3306/$oozie_db_name",
		jdbc_database     => "$oozie_db_name",
		jdbc_username     => "$oozie_db_user",
		jdbc_password     => "$oozie_db_pass",
		subscribe         => Exec["oozie_mysql_create_database"],
		require           => Exec["oozie_mysql_create_database"],
	}
	
}