# == Class: duplicity_mysql::params
#
# Default values of the duplicity_mysql class.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity_mysql::params {
  $backup_dir = $facts['os']['family'] ? {
    default => '/var/backups/mysql'
  }

  $dump_script_template = 'duplicity_mysql/usr/local/sbin/dump-mysql-database.sh.erb'
  $dump_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/dump-mysql-database.sh'
  }

  $check_script_template = 'duplicity_mysql/usr/local/sbin/check-mysql-database.sh.erb'
  $check_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/check-mysql-database.sh'
  }

  $restore_script_template = 'duplicity_mysql/usr/local/sbin/restore-mysql-database.sh.erb'
  $restore_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/restore-mysql-database.sh'
  }

  $option_file = $facts['os']['family'] ? {
    default => "${::root_home}/.my.cnf"
  }

  $mysql_client_package_name = $facts['os']['family'] ? {
    default => 'mysql-client'
  }
  $grep_package_name = $facts['os']['family'] ? {
    default => 'grep'
  }
  $gzip_package_name = $facts['os']['family'] ? {
    default => 'gzip'
  }
}
