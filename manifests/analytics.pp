class role::analytics {
	# TODO, remove apt_source when we go to production
	include analytics_temp

	# install common cdh4 packages and config
	class { "cdh4":
		require => Class["cloudera::apt_source"],
	}

	# zookeeper config is common to all nodes
	class { "analytics::zookeeper::config":
		require => Class["cloudera::apt_source"]
	}
	# 
	# # kafka client and config is common to all nodes
	# class { "analytics::kafka::client":
	# 	require => File["/etc/apt/sources.list.d/kraken.list"],
	# }
}




class role::analytics::master($hadoop_mounts) inherits role::analytics {
	# hadoop config for namenode
	class { "analytics::hadoop::config":
		require => Class["cloudera::apt_source"],
		hadoop_mounts => undef,
	}

	# hadoop metrics is common to all nodes
	class { "analytics::hadoop::metrics":
		require => Class["analytics::hadoop::config"],
	}
	
	
	
	# hadoop master (namenode, etc.)
	include cdh4::hadoop::master
	# oozier server
	include analytics::oozie::server
	# hive metastore and hive server
	include analytics::hive::server

	# hue server
	class { "cdh4::hue":
		# TODO:  Change secret_key and put it in private puppet repo.
		secret_key => "MQBvbk9fk9u1hSr7S13auZyYbRAPK0BbSr6k0NLokTNswv1wNU4v90nUhZE3",
		require    => Class["cdh4::oozie::server"],
	}
	
	
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

class role::analytics::worker($hadoop_mounts) inherits role::analytics {
	# hadoop config for datanodes
	class { "analytics::hadoop::config":
		require => Class["cloudera::apt_source"],
		hadoop_mounts => $hadoop_mounts,
	}

	# hadoop metrics is common to all nodes
	class { "analytics::hadoop::metrics":
		require => Class["analytics::hadoop::config"],
	}

	# hadoop worker (datanode, etc.)
	include cdh4::hadoop::worker
}

class role::analytics::zookeeper inherits role::analytics {
	# zookeeper server
	include analytics::zookeeper::server
}

class role::analytics::kafka inherits role::analytics {
	# kafka broker server
	require analytics::zookeeper::config

	include kafka, kafka::install
	class { "kafka::config":
		zookeeper_hosts => $analytics::zookeeper::config::zookeeper_hosts,
	}
	include kafka::server
}



class analytics::hadoop::config($hadoop_mounts) {
	$namenode_hostname        = "analytics1001.wikimedia.org"
	$hadoop_base_directory    = "/var/lib/hadoop"
	$hadoop_name_directory    = "$hadoop_base_directory/name"

	class { "cdh4::hadoop::config":
		namenode_hostname    => $namenode_hostname,
		dfs_data_dir_mounts  => $hadoop_mounts,
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

class analytics::hadoop::metrics {
	class { "cdh4::hadoop::metrics":
		# TODO:  Use analytics ganglia cluster mcast_address from ganglia.pp in production.
		ganglia_hosts => ["239.192.1.32:8649"],
	}
}

class analytics::packages::mysql_java {
	package { "libmysql-java":
		ensure => installed,
	}	
}



class analytics::oozie::server {
	require analytics::packages::mysql_java
	# require analytics::db::mysql

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
	
	# The WF_JOBS proto_action_conf is TEXT type by default.
	# This isn't large enough for things that hue submits.
	# Change it to MEDIUMTEXT.
	exec { "oozie_alter_WF_JOBS":
		command => "/usr/bin/mysql -e 'ALTER TABLE oozie.WF_JOBS CHANGE proto_action_conf proto_action_conf MEDIUMTEXT;'",
		unless  => "/usr/bin/mysql -e 'SHOW CREATE TABLE oozie.WF_JOBS\\G' | grep proto_action_conf | grep -qi mediumtext",
		user    => "root",
		require => Exec["oozie_mysql_create_database"],
	}

	class { "cdh4::oozie::server":
		jdbc_driver       => "com.mysql.jdbc.Driver",
		jdbc_url          => "jdbc:mysql://localhost:3306/$oozie_db_name",
		jdbc_database     => "$oozie_db_name",
		jdbc_username     => "$oozie_db_user",
		jdbc_password     => "$oozie_db_pass",
		subscribe         => Exec["oozie_mysql_create_database"],
		require           => [File["/var/lib/oozie/mysql.jar"], Exec["oozie_mysql_create_database"]],
	}
}




class analytics::hive::server {
	require analytics::packages::mysql_java
	# require analytics::db::mysql

	# symlink the mysql.jar into /var/lib/hive/lib
	file { "/usr/lib/hive/lib/mysql.jar":
		ensure  => "/usr/share/java/mysql.jar",
		require => [Package["libmysql-java"], Package["hive-metastore"], Package["hive-server"]],
	}

	$hive_db_name    = "hive_metastore"
	$hive_db_user    = "hive"
	# TODO: put this in private puppet repo
	$hive_db_pass    = "hive"

	# name for hive db stats.
	# the same mysql user will be used.
	$hive_stats_db_name = "hive_metrics"

	# hive is going to need an hive database and user.
	exec { "hive_mysql_create_database":
		command => "/usr/bin/mysql -e \"CREATE DATABASE $hive_db_name; USE $hive_db_name; SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.8.0.mysql.sql;\"",
		unless  => "/usr/bin/mysql -e 'SHOW DATABASES' | /bin/grep -q $hive_db_name",
		user    => "root",
	}

	exec { "hive_mysql_create_stats_database":
		command => "/usr/bin/mysql -e \"CREATE DATABASE $hive_stats_db_name; USE $hive_stats_db_name;\"",
		unless  => "/usr/bin/mysql -e 'SHOW DATABASES' | /bin/grep -q $hive_stats_db_name",
		user    => "root",
	}

	exec { "hive_mysql_create_user":
		command => "/usr/bin/mysql -e \"CREATE USER '$hive_db_user'@'localhost' IDENTIFIED BY '$hive_db_pass'; CREATE USER '$hive_db_user'@'127.0.0.1' IDENTIFIED BY '$hive_db_pass'; GRANT ALL PRIVILEGES ON $hive_db_name.* TO '$hive_db_user'@'localhost' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON $hive_db_name.* TO '$hive_db_user'@'127.0.0.1' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON $hive_stats_db_name.* TO '$hive_db_user'@'localhost' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON $hive_stats_db_name.* TO '$hive_db_user'@'127.0.0.1' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
		unless  => "/usr/bin/mysql -e \"SHOW GRANTS FOR '$hive_db_user'@'127.0.0.1'\" | grep -q \"TO '$hive_db_user'\"",
		user    => "root",
	}

	class { "cdh4::hive::server":
		jdbc_driver              => "com.mysql.jdbc.Driver",
		jdbc_url                 => "jdbc:mysql://localhost:3306/$hive_db_name",
		jdbc_username            => "$hive_db_user",
		jdbc_password            => "$hive_db_pass",
		stats_enabled            => true,
		stats_dbclass            => "jdbc:mysql",
		stats_jdbcdriver         => "com.mysql.jdbc.Driver",
		stats_dbconnectionstring => "jdbc:mysql://localhost:3306/$hive_stats_db_name?user=$hive_db_user&amp;password=$hive_db_pass",
		require                  => [File["/usr/lib/hive/lib/mysql.jar"], Exec["hive_mysql_create_database"], Exec["hive_mysql_create_user"]],
		subscribe                => [Exec["hive_mysql_create_database"], Exec["hive_mysql_create_user"]]
	}
}

class analytics::zookeeper::config {
	$zookeeper_hosts = [
		"analytics1023.eqiad.wmnet",
		"analytics1024.eqiad.wmnet",
		"analytics1025.eqiad.wmnet"
	]

	class { "cdh4::zookeeper::config":
		zookeeper_hosts => $zookeeper_hosts,
	}
}


class analytics::zookeeper::server {
	require analytics::zookeeper::config
	include cdh4::zookeeper::server
}
