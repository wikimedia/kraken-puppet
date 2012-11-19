# == Class analytics::hue
# 
class analytics::hue {
	# hue server
	class { "cdh4::hue":
		# TODO:  Change secret_key and put it in private puppet repo.
		secret_key => "MQBvbk9fk9u1hSr7S13auZyYbRAPK0BbSr6k0NLokTNswv1wNU4v90nUhZE3",
		require    => [Class["analytics::hadoop::config"], Class["analytics::oozie::server"], Class["analytics::hive::server"]],
	}
}