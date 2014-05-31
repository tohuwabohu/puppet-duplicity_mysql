# == Define: duplicity_mysql::database
#
# Create a backup of the named database.
#
# === Parameters
#
# [*ensure*]
#   Set state the package should be in. Can be either present (= backup and restore if not existing), backup (= backup
#   only), or absent.
#
# [*database*]
#   Set the name of the database.
#
# [*profile*]
#   Set the name of the duplicity profile where the database dump file is added to. The profile's backup will be
#   queried when the dump file is not existing and a restore is kicked off.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity_mysql::database(
  $ensure   = present,
  $database = $title,
  $profile  = 'backup',
) {
  require duplicity_mysql

  if $ensure !~ /^present|backup|absent$/ {
    fail("Duplicity_Mysql::Database[${title}]: ensure must be either present, backup or absent, got '${ensure}'")
  }
  if $ensure =~ /^present|backup$/ and empty($profile) {
    fail("Duplicity_Mysql::Database[${title}]: profile must not be empty")
  }

  $dump_file = "${duplicity_mysql::backup_dir}/${database}.sql.gz"
  $exec_before_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }

  duplicity::profile_exec_before { "${profile}/mysql/${database}":
    ensure  => $exec_before_ensure,
    profile => $profile,
    content => "${duplicity_mysql::dump_script_path} ${database}",
    order   => '10',
  }

  duplicity::file { $dump_file:
    ensure  => $ensure,
    profile => $profile
  }

  if $ensure == present {
    exec { "${duplicity_mysql::restore_script_path} ${database}":
      onlyif  => "${duplicity_mysql::check_script_path} ${database}",
      require => Duplicity::File[$dump_file],
    }
  }
}
