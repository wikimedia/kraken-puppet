# Puppet module to install components of Cloudera's Distribution 4
# for Apache Hadoop, to be managed by Cloudera SCM

# This puppet module was adapted from a CDH3 module.
# NOTE.  Only YARN is currently supported by this module.

## Description
Currently installs HDFS, mapred, hive, hbase, and zookeeper
Note that, in order for this module to work, you will have to ensure that:
* sun jre version 6 or greater is installed
* the mysql jdbc connector is installed
* your package manager is configured with a repository containing the
  cdh packages


## Usage

### cdh
<pre>
include cdh4::master
# OR
include cdh4::slave
</pre>

