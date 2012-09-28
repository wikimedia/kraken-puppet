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

class cdh {
	include hadoop
	include hbase
	include hive
	include zookeeper
	include pig
	include oozie
}


class cdh::apt_source($version = 'cdh4') {
	file { "/etc/apt/sources.list.d/cloudera.list":
		content => "deb http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\ndeb-src http://archive.cloudera.com/debian ${lsbdistcodename}-${version} contrib\n",
		mode    => 0444,
		ensure  => 'present',
	}

	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/debian/archive.key | /usr/bin/apt-key add -",
		require   => Package["curl"],
		subscribe => File["/etc/apt/sources.list.d/cloudera.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
	}

	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cloudera.list"], Exec["import_cloudera_apt_key"]],
	}
}
