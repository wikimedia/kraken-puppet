class dse::cassandra::service {
    service { $dse::cassandra::server::service_name:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        # Not subscribing dse service to 
        # config files.  I'd rather not have
        # Cassandra restarted automatically.
        # subscribe  => Class['dse::cassandra::config'],
        require    => Class['dse::cassandra::config'],
    }
}