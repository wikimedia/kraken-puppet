# WMF Kraken Analytics Puppet Module

The analytics module contains site specific configurations for
the WMF Analytics Kraken cluster.  Each file contains classes for
configuring different pieces of a specific service.  For example,
In order to set up a new Hadoop worker node:

```puppet
node new_worker {
  include analytics::hadoop::worker
}_
```

See also manifests/roles/analytics.pp for logical groupings of
different services.


