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
  $dump_script_template       = params_lookup('dump_script_template'),
  $dump_script_path           = params_lookup('dump_script_path'),
  $check_script_template      = params_lookup('check_script_template'),
  $check_script_path          = params_lookup('check_script_path'),
  $restore_script_template    = params_lookup('restore_script_template'),
  $restore_script_path        = params_lookup('restore_script_path'),
  $option_file                = params_lookup('option_file'),
  $backup_dir                 = params_lookup('backup_dir'),
  $mysql_client_package_name  = params_lookup('mysql_client_package_name'),
  $grep_package_name          = params_lookup('grep_package_name'),
  $gzip_package_name          = params_lookup('gzip_package_name'),
) inherits duplicity_mysql::params {

  if empty($dump_script_template) {
    fail('Class[Duplicity_Mysql]: dump_script_template must not be empty')
  }
  validate_absolute_path($dump_script_path)
  validate_absolute_path($option_file)
  validate_absolute_path($backup_dir)
  if empty($mysql_client_package_name) {
    fail('Class[Duplicity_Mysql]: mysql_client_package_name must not be empty')
  }
  if empty($gzip_package_name) {
    fail('Class[Duplicity_Mysql]: gzip_package_name must not be empty')
  }

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
