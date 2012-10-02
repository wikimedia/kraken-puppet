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

class cdh4 {
	include hadoop
	# include hbase
	# include hive
	include zookeeper
	include pig
	# include oozie
}


class cdh4::apt_source {
	$operatingsystem_lowercase = inline_template("<%= operatingsystem.downcase %>")

	file { "/etc/apt/sources.list.d/cdh4.list":
		content => "deb [arch=${architecture}] http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh4 contrib\ndeb-src http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh4 contrib\n",
		mode    => 0444,
		ensure  => 'present',
	}
	
	if $hostname != 'analytics1001' {
		Exec {
			environment => "http_proxy=http://brewster.wikimedia.org:8080"
		}
	}

	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh/archive.key | /usr/bin/apt-key add -",
		subscribe => File["/etc/apt/sources.list.d/cdh4.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
	}

	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cdh4.list"], Exec["import_cloudera_apt_key"]],
	}
}
