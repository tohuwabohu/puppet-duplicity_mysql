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
  $ensure = present,
  $database = $title,
  $profile = undef,
) {
  require duplicity_mysql

  if $ensure !~ /^present|backup|absent$/ {
    fail("Duplicity_Mysql::Database[${title}]: ensure must be either present, backup or absent, got '${ensure}'")
  }
  if $ensure =~ /^present|backup$/ and empty($profile) {
    fail("Duplicity_Mysql::Database[${title}]: profile must not be empty")
  }

  $profile_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_pre_script = "${profile_dir}/${duplicity::params::duply_profile_pre_script_name}"
  $profile_filelist = "${profile_dir}/${duplicity::params::duply_profile_filelist_name}"
  $dump_script_path = $duplicity_mysql::dump_script_path
  $dump_file = "${duplicity_mysql::backup_dir}/${database}.sql.gz"

  concat::fragment { "${profile_pre_script}/mysql/${database}":
    target  => $profile_pre_script,
    content => "${dump_script_path} ${database}\n",
    order   => '10',
  }
  duplicity::file { $dump_file:
    ensure  => $ensure,
    profile => $profile
  }
}
