class analytics::hadoop::config {
	$namenode_hostname        = "analytics1010.eqiad.wmnet"
	$hadoop_name_directory    = "/var/lib/hadoop/name"

	$hadoop_data_directory    = "/var/lib/hadoop/data"
	$datanode_mounts = [
		"$hadoop_data_directory/c",
		"$hadoop_data_directory/d",
		"$hadoop_data_directory/e",
		"$hadoop_data_directory/f",
		"$hadoop_data_directory/g",
		"$hadoop_data_directory/h",
		"$hadoop_data_directory/i",
		"$hadoop_data_directory/j",
		"$hadoop_data_directory/k",
		"$hadoop_data_directory/l"
	]
	
	class { "cdh4::hadoop::config":
		namenode_hostname    => $namenode_hostname,
		datanode_mounts      => $datanode_mounts,
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