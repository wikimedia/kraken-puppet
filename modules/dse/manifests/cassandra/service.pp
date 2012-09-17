class dse::cassandra::service {
    service { $dse::cassandra::service_name:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        subscribe  => Class['dse::cassandra::config'],
        require    => Class['dse::cassandra::config'],
    }
}