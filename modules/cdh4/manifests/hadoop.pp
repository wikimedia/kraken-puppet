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

class cdh4::hadoop {
  include cdh4::hadoop::install
}

# == Class cdh4::hadoop::master
#
# The Hadoop Master is the namenode, jobtracker (MRv1) and resource manager, proxy server and history server (YARN)
class cdh4::hadoop::master($enable_yarn = true, $enable_mapreduce_v1 = true) inherits cdh4::hadoop {
	include cdh4::hadoop::service::namenode

	if ($enable_mapreduce_v1) {
		include cdh4::hadoop::service::jobtracker
	}
	if ($enable_yarn) {
		include cdh4::hadoop::service::resourcemanager
	}
}

# == Class cdh4::hadoop::slave
#
# The Hadoop Master is the datanode, tasktracker (MRv1) and node manager (YARN)

class cdh4::hadoop::slave($enable_yarn = true, $enable_mapreduce_v1 = true) inherits cdh4::hadoop {
	include cdh4::hadoop::service::datanode
	
	if ($enable_mapreduce_v1) {
		include cdh4::hadoop::service::tasktracker
	}
	if ($enable_yarn) {
		include cdh4::hadoop::service::nodemanager
	}
}