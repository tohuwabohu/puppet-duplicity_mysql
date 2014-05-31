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
  $backup_dir = $::osfamily ? {
    default => '/var/backups/mysql'
  }

  $dump_script_template = 'duplicity_mysql/usr/local/sbin/dump-mysql-database.sh.erb'
  $dump_script_path = $::osfamily ? {
    default => '/usr/local/sbin/dump-mysql-database.sh'
  }

  $check_script_template = 'duplicity_mysql/usr/local/sbin/check-mysql-database.sh.erb'
  $check_script_path = $::osfamily ? {
    default => '/usr/local/sbin/check-mysql-database.sh'
  }

  $restore_script_template = 'duplicity_mysql/usr/local/sbin/restore-mysql-database.sh.erb'
  $restore_script_path = $::osfamily ? {
    default => '/usr/local/sbin/restore-mysql-database.sh'
  }

  $option_file = $::osfamily ? {
    default => "${::root_home}/.my.cnf"
  }

  $mysql_client_package_name = $::osfamily ? {
    default => 'mysql-client'
  }
  $grep_package_name = $::osfamily ? {
    default => 'grep'
  }
  $gzip_package_name = $::osfamily ? {
    default => 'gzip'
  }
}
