
class kraken::oozie::server {
	require kraken::packages::mysql_java
	# require kraken::db::mysql

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
