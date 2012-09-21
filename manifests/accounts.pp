
# NOTE!  This file will be deleted when these
# configs go to production.

class kraken_accounts {
	include declerambaul
	include olivneh
	include erosen
	include diederik
}

class diederik inherits baseaccount {
	$username = "diederik"
	$realname = "Diederik van Liere"
	$uid = 565

	unixaccount { $realname: username => $username, uid => $uid, gid => $gid }

	Ssh_authorized_key { require => Unixaccount[$realname]}

	ssh_authorized_key { "diederik@Diederik-Van-Lieres-MacBook-Pro.local":
			ensure	=> present,
			user	=> $username,
			type	=> "ssh-rsa",
			key	=> "AAAAB3NzaC1yc2EAAAABIwAAAgEAtpE5YKnKPgHmFG5a8x/1lfgRUIFhv8Vug/57XCMeuQMG8NNUuQAno1OWYT1ukla7DO/3KF+iWAkyLlUq3z+rO9WB8/BuxLOsNBd0dBF44yoVsjKkTCdkuhh/3a47uIGAKhGG5Cj+c1ggAnKGLMgfoaF2H5vifhSp0hJbRGMXxzC+OoVq0X34GnkEZK7YZAg2oYVOyLRbOYNDlXLdIUoQ0579/T8/ey8mZzbxuONZy7UuRiFxwOB3O88s5SBhGwKHR/3iJ63PE5KZ+OCBg6nTPM+4rYfQHIy8lwvna2OAgweoqQRmn1NFpZisqhWcAAABKTyJ6MYQu1J/6SdGI4QehWEinsPud/ZJ7EbrAWotLTnDaeQnPwdQnSNVTTm6FWKjkKAbzcIRpWqw32L5fMU/hwmJ9K2GQSYHxdiGIdlgXsI+Pel4dyhtbl/UT3Zj+BWg71rGF4SY7lHCfAm+3FbbBa4wHSQExa6k6cFUAv2mPnUuBeLKBPZnZc4kRBehiVV16ddiyYgDwhjO3s1CLcPLz4napVDviMj4QSC1Em1NsqKPNIwITC9rqFuxhjoT9Gz7FpA4OWkQaqECkO/L2NjP6vTlxfpof3tD9+aagCfI11JNNG06oFMjc+GhvObQmUA1ZtV4xNhYhFJDhvSmxNwF8Bux2dpPwaaemBZtgfUEszs=";
	}
}


class erosen inherits baseaccount {
	$username = "erosen"
	$realname = "Evan Rosen"
	$uid = 602
	unixaccount { $realname: username => $username, uid => $uid, gid => $gid }
	Ssh_authorized_key { require => Unixaccount[$realname] }
	ssh_authorized_key {
		"erosen@wikimedia.org":
			ensure => present,
			user   => $username,
			type   => "ssh-rsa",
			key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDGV+SyDPodS8lRJBv/JndZJ7pbM3mlqMN2bbE8ABUj5P5YYOiJDoLjPr8hczeYt1qMhbepp89nLSqUD8BgoJVNoiUokmi4lKK0PnPhqGVN+RFnamlHCibAPjbEBWaBWEl0u/9EtU4S0r7uQaKEnNJwcr7/8lu4KzDznViUVACGDdGpyRLZ388Phu93HOK2KPXtyxZPlwjW6wKIN3nyhew0X7LxzYF8rINl3Nf4lUF1fnK2NbfEq3S0bQfVcyWwRrgMUMA+w0plJQpHdLr+agvZo/SdtFrNFugQrMk1d+FNzEFnoDshwHfcmwjSaU+M8ZdbS+jq97X8HoL22yXFyD/B",
	}
}

class declerambaul inherits baseaccount {
	$username = "declerambaul"
	$realname = "Fabian Kaelin"
	$uid = 566

	unixaccount { $realname: username => $username, uid => $uid }

	ssh_authorized_key { "declerambaul_wiki":
		ensure	=> present,
		user	=> $username,
		type	=> "ssh-rsa",
		key    	=> "AAAAB3NzaC1yc2EAAAABIwAAAQEA3aScUQs0HeQEp/pnMuJ6JKWTwEa8IPVKa7Gkrx2DJ3z1qUtA5wzxSG6m//MJBokIntwBAGuqRazAqs5cB3m4GVqViA1fabxZy55l1/GB+962/d8goVEbtkj/MO47vuUBosVSy5GGjGOs3hWtKId9q6+AU0OCNZwC3j12tXGIX3ztcf4Ef2pdBoCfJMgrvlnIpdFDBftrua9kVvYRQj6tVr5rTbFlEioNgNcdQXhvDP0sU81i1NG/nAeOZMDYOzUscDHa6JcCts3nRyqrqgaMixxGjF7WG42tqS+AEqKi9IOqFnaiHtwipZrnJJ8IxtDOve3HHA3VctBsh03qB4RZ6w==",
		require => Unixaccount[$realname],
	}
}

class olivneh inherits baseaccount {
	$username = "olivneh"
	$realname = "Ori Livneh"
	$uid = 604
	unixaccount { $realname: username => $username, uid => $uid, gid => $gid }
	ssh_authorized_key {
		"Olivneh@WMF":
			ensure	=> present,
			user	=> $username,
			type	=> "ssh-rsa",
			key	=> "AAAAB3NzaC1yc2EAAAADAQABAAABAQC5sz9Sq9+vAas4hY9HdVV0/xukFFRJj0NMDuWY4cRf/MKXkGwQB2CVEa6/owW3G1dbC3t5viimS347DoQh9SHy9ltpnrjga5sd/8RLV/7FSs2QjG+WtMwEupAfO1YRUzWEYCbs/sYJ/dYjY6hdJJfByxH8XOQHXI6hiddjqZ7XrQUq9IVYb6rm/Td7OmwD5/T2l1YXVa/w4DHqVMEnXxtSo4Njww2BwmEYPIa9HusE8TblpAs1B78ixVLCSAg7/VLXDj2mzeX75bID3To9CvxRxPbLKJpSy/yRHM8p5XJ55ZZjp+pmkdOj/kcdvqiEe2KhfdVgXS4Ywk1/R4ZGlA+9",
			require => Unixaccount[$realname],
	}
}


class baseaccount {
	$enabled = "true"

	Ssh_authorized_key {
		ensure => $enabled ? {
			"false" => 'absent',
			 default => 'present',
			}
	}
}


define account_ssh_key($user, $type, $key, $enabled="true") {
	ssh_authorized_key { $title:
		user => $user,
		type => $type,
		key => $key,
	}
}


define unixaccount($username, $uid, $gid = 500, $enabled="true") {


	if ($myshell) {
		$shell = $myshell
	} else {
		$shell = "/bin/bash"
	}

	user { "${username}":
		name		=> $username,
		uid		=> $uid,
		gid		=> $gid,
		comment		=> $title,
		shell		=> $shell,
		ensure		=> $enabled ? {
					"false" => 'absent',
					default => 'present',
				},
		managehome	=> true,
		allowdupe	=> false,
		# require		=> Group[$gid],
	}
}