import "nodes.pp"
import "accounts.pp"

# this class does things that ops production
# usually does, or that we will not need
# in production when we are finished with testing.
class analytics_temp {
	# Make sure puppet runs apt-get update!
	exec { "/usr/bin/apt-get update":
		timeout => 240,
		returns => [ 0, 100 ],
	}

	package { ["curl", "dstat"]: ensure => "installed" }

	file { "/etc/profile.d/analytics.sh":
		content => 'export http_proxy="http://brewster.wikimedia.org:8080"

alias pupup="pushd .; cd /etc/puppet.analytics && sudo git pull; popd"
alias puptest="sudo puppetd --test --verbose --server analytics1001.wikimedia.org --vardir /var/lib/puppet.analytics --ssldir /var/lib/puppet.analytics/ssl --confdir=/etc/puppet.analytics"
alias pupsign="sudo puppetca --vardir /var/lib/puppet.analytics --ssldir /var/lib/puppet.analytics/ssl --confdir=/etc/puppet.analytics sign "',
		mode => 755,
	}
	 
	include kraken_accounts
	
	include analytics::http_proxy
}


class analytics::hadoop::config {
	$namenode_hostname        = "analytics1001.wikimedia.org"
	$hadoop_base_directory    = "/var/lib/hadoop"
	$hadoop_name_directory    = "$hadoop_base_directory/name"
	$hadoop_data_directory    = "$hadoop_base_directory/data"
	
	$hadoop_mounts = [
		"$hadoop_data_directory/e",
		"$hadoop_data_directory/f",
		"$hadoop_data_directory/g",
		"$hadoop_data_directory/h",
		"$hadoop_data_directory/i",
		"$hadoop_data_directory/j",
	]


	class { "cdh4::hadoop::config":
		namenode_hostname => $namenode_hostname,
		mounts            => $hadoop_mounts,
		dfs_name_dir  => [$hadoop_name_directory],
		# dfs_block_size => "536870912", # 512MB 
		# dfs_block_size => "268435456", # 256MB 
		# dfs_block_size => "134217728", # 128MB
	}
}

class analytics::http_proxy {
	package { "apache2": ensure => installed }
	service { "apache2": ensure => running }
	
	
	file { "/etc/apache2/sites-available/proxy":
		notify => Service["apache2"],
		content => '
Listen 8085
<VirtualHost *:8085>
	ErrorLog /var/log/apache2/error.log
	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog /var/log/apache2/access.log combined
	ServerSignature On

	ProxyRequests Off
	<Proxy *>
		Order allow,deny
		Allow from all
	</Proxy>

	UseCanonicalName Off
	UseCanonicalPhysicalPort Off

	RewriteEngine On
	RewriteLog /var/log/apache2/rewrite.log
	RewriteLogLevel 9
	RewriteRule "^(.*)" "http://%{HTTP_HOST}$1" [P]

	<Location />
		Order deny,allow
		AuthType Basic
		AuthName "wmf-analytics"
		AuthUserFile /srv/.htpasswd
		require valid-user
	</Location>
</VirtualHost>
'
	}
	
	file { "/etc/apache2/sites-enabled/proxy":
		notify => Service["apache2"],
		ensure => "/etc/apache2/sites-available/proxy",
	}
}