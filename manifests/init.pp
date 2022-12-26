# == Class: duplicity_mysql
#
# Manage scripts to backup and restore MySQL databases.
#
# The following scripts are managed:
#   * Dump a given database to a file
#   * Check if a given database is empty
#   * Restore a given dump file into a database
#
# === Parameters
#
# [*dump_script_template*]
#   Set the template to be used when creating the dump script.
#
# [*dump_script_path*]
#   Set the path where to write the dump script to.
#
# [*check_script_template*]
#   Set the template to be used when creating the check script.
#
# [*check_script_path*]
#   Set the path where to write the check script to.
#
# [*restore_script_template*]
#   Set the template to be used when creating the restore script.
#
# [*restore_script_path*]
#   Set the path where to write the restore script to.
#
# [*option_file*]
#   Set the path to the option file containing username and password to access the database.
#
# [*backup_dir*]
#   Set the directory where to store the dump files.
#
# [*mysql_client_package_name*]
#   Set the name of the package which contains the mysqldump utility.
#
# [*grep_package_name*]
#   Set the name of the package which contains the grep utility.
#
# [*gzip_package_name*]
#   Set the name of the package which contains the gzip utility.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity_mysql(
  String $dump_script_template = $duplicity_mysql::params::dump_script_template,
  Stdlib::Absolutepath $dump_script_path = $duplicity_mysql::params::dump_script_path,
  String $check_script_template = $duplicity_mysql::params::check_script_template,
  Stdlib::Absolutepath $check_script_path = $duplicity_mysql::params::check_script_path,
  String $restore_script_template = $duplicity_mysql::params::restore_script_template,
  Stdlib::Absolutepath $restore_script_path = $duplicity_mysql::params::restore_script_path,
  Stdlib::Absolutepath $option_file = $duplicity_mysql::params::option_file,
  Stdlib::Absolutepath $backup_dir = $duplicity_mysql::params::backup_dir,
  String $mysql_client_package_name = $duplicity_mysql::params::mysql_client_package_name,
  String $grep_package_name = $duplicity_mysql::params::grep_package_name,
  String $gzip_package_name = $duplicity_mysql::params::gzip_package_name,
) inherits duplicity_mysql::params {
  file { $backup_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { $dump_script_path:
    ensure  => file,
    content => template($dump_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$option_file],
      File[$backup_dir],
      Package[$mysql_client_package_name],
      Package[$gzip_package_name],
    ]
  }

  file { $check_script_path:
    ensure  => file,
    content => template($check_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$option_file],
      Package[$mysql_client_package_name],
      Package[$grep_package_name],
    ]
  }

  file { $restore_script_path:
    ensure  => file,
    content => template($restore_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$option_file],
      File[$backup_dir],
      Package[$mysql_client_package_name],
      Package[$gzip_package_name],
    ]
  }
}
