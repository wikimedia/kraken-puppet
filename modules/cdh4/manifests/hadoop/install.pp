#
#  Copyright (c) 2011, Cloudera, Inc. All Rights Reserved.
#
#  Cloudera, Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"). You may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for
#  the specific language governing permissions and limitations under the
#  License.
#

class cdh4::hadoop::install::client {
	# install hadoop-client, all nodes should have this.
	package { "hadoop-client": ensure => installed }
}

class cdh4::hadoop::install::namenode {
	# install namenode daemon package
	package { "hadoop-hdfs-namenode": ensure => installed }
}

class cdh4::hadoop::install::secondarynamenode {
	# install secondarynamenode daemon package
	package { "hadoop-hdfs-secondarynamenode": ensure => installed }
}

class cdh4::hadoop::install::datanode {
	# install datanode daemon package
	package { "hadoop-hdfs-datanode": ensure => installed }
}

#
# YARN packages
#

class cdh4::hadoop::install::resourcemanager {
	# ResourceManager is on the NameNode
	require cdh4::hadoop::install::namenode

	# install resourcemanager daemon package
	# (Analagous to JobTracker)
	package { "hadoop-yarn-resourcemanager": ensure => installed }
}


class cdh4::hadoop::install::nodemanager {
	# nodemanagers are also datanodes
	require cdh4::hadoop::install::datanode

	# install nodemanager and mapreduce (YARN) daemon package
	# (Analagous to TaskTracker)
	package { ["hadoop-yarn-nodemanager", "hadoop-mapreduce"]: ensure => installed }
}

class cdh4::hadoop::install::historyserver {
	# install historyserver daemon package
	package { "hadoop-mapreduce-historyserver": ensure => installed }
}

class cdh4::hadoop::install::proxyserver {
	# install proxyserver daemon package
	package { "hadoop-yarn-proxyserver": ensure => installed }
}
