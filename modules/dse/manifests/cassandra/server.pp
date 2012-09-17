# == Class cassandra
#
# Note:  This was taken and modified from
# https://github.com/smarchive/puppet-cassandra/blob/master/manifests/init.pp

class dse::cassandra::server(
    $package_name               = $dse::cassandra::params::package_name,
    $service_name               = $dse::cassandra::params::service_name,
    $repo_name                  = $dse::cassandra::params::repo_name,
    $repo_baseurl               = $dse::cassandra::params::repo_baseurl,
    $repo_gpgkey                = $dse::cassandra::params::repo_gpgkey,
    $repo_repos                 = $dse::cassandra::params::repo_repos,
    $repo_release               = $dse::cassandra::params::repo_release,
    $repo_pin                   = $dse::cassandra::params::repo_pin,
    $repo_gpgcheck              = $dse::cassandra::params::repo_gpgcheck,
    $repo_enabled               = $dse::cassandra::params::repo_enabled,
    $max_heap_size              = $dse::cassandra::params::max_heap_size,
    $heap_newsize               = $dse::cassandra::params::heap_newsize,
    $stack_size                 = $dse::cassandra::params::stack_size,
    $jmx_port                   = $dse::cassandra::params::jmx_port,
    $additional_jvm_opts        = $dse::cassandra::params::additional_jvm_opts,
    $cluster_name               = $dse::cassandra::params::cluster_name,
    $listen_address             = $dse::cassandra::params::listen_address,
    $rpc_address                = $dse::cassandra::params::rpc_address,
    $rpc_port                   = $dse::cassandra::params::rpc_port,
    $rpc_server_type            = $dse::cassandra::params::rpc_server_type,
    $storage_port               = $dse::cassandra::params::storage_port,
    $partitioner                = $dse::cassandra::params::partitioner,
    $data_file_directories      = $dse::cassandra::params::data_file_directories,
    $commitlog_directory        = $dse::cassandra::params::commitlog_directory,
    $saved_caches_directory     = $dse::cassandra::params::saved_caches_directory,
    $initial_token              = $dse::cassandra::params::initial_token,
    $seeds                      = $dse::cassandra::params::seeds,
    $concurrent_reads           = $dse::cassandra::params::concurrent_reads,
    $concurrent_writes          = $dse::cassandra::params::concurrent_writes,
    $incremental_backups        = $dse::cassandra::params::incremental_backups,
    $snapshot_before_compaction = $dse::cassandra::params::snapshot_before_compaction,
    $auto_snapshot              = $dse::cassandra::params::auto_snapshot,
    $multithreaded_compaction   = $dse::cassandra::params::multithreaded_compaction,
    $endpoint_snitch            = $dse::cassandra::params::endpoint_snitch
) inherits dse::cassandra::params {
    # Validate input parameters

    # TODO:  are these only available with Puppet Enterprise???

    # validate_absolute_path($commitlog_directory)
    # validate_absolute_path($saved_caches_directory)
    # 
    # validate_string($cluster_name)
    # validate_string($partitioner)
    # validate_string($initial_token)
    # validate_string($endpoint_snitch)
    # 
    # validate_re($rpc_server_type, ['^hsha$', '^sync$', '^async$'])
    # validate_re($incremental_backups, ['^true$', '^false$'])
    # validate_re($snapshot_before_compaction, ['^true$', '^false$'])
    # validate_re($auto_snapshot, ['^true$', '^false$'])
    # validate_re($multithreaded_compaction, ['^true$', '^false$'])
    # validate_re("${concurrent_reads}", '^[0-9]+$')
    # validate_re("${concurrent_writes}", '^[0-9]+$')
    # 
    # validate_array($additional_jvm_opts)
    # validate_array($seeds)
    # validate_array($data_file_directories)

    if(!is_integer($jmx_port)) {
        fail('jmx_port must be a port number between 1 and 65535')
    }

    if(!is_ip_address($listen_address)) {
        fail('listen_address must be an IP address')
    }

    if(!is_ip_address($rpc_address)) {
        fail('rpc_address must be an IP address')
    }

    if(!is_integer($rpc_port)) {
        fail('rpc_port must be a port number between 1 and 65535')
    }

    if(!is_integer($storage_port)) {
        fail('storage_port must be a port number between 1 and 65535')
    }

    if(empty($seeds)) {
        fail('seeds must not be empty')
    }

    if(empty($data_file_directories)) {
        fail('data_file_directories must not be empty')
    }

    class { "dse::cassandra::config": }
	class { "dse::cassandra::service": require => Class['dse::cassandra::config'] }
}






