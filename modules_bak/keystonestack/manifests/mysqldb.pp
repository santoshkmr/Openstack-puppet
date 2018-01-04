class keystonestack::mysqldb (
 $dbname     = $keystonestack::params::dbname,
 $dbpasswd   = $keystonestack::params::dbpasswd,
 $privileges = $keystonestack::params::privileges,
 $dbuser     = $keystonestack::params::dbuser,
 $grant      = $keystonestack::params::grant,
) inherits keystonestack::params

{
 mysql::db {
  $dbname:
    user       => $dbuser,
    host       => 'localhost',
    grant      => $grant,
    before     => [Mysql_grant["${dbuser}@localhost/*.*"],Mysql_grant["${dbuser}@%/*.*"]],
    password   => $dbpasswd,
  }
 mysql_grant {
  "${dbuser}@localhost/*.*":
    ensure     => 'present',
    user       => "${dbuser}@localhost",
    table      => '*.*',
    options    => ['GRANT'],
    privileges => $privileges,
  }
 mysql_grant {
 "${dbuser}@%/*.*":
    ensure     => 'present',
    user       => "${dbuser}@%",
    table      => '*.*',
    options    => ['GRANT'],
    privileges => $privileges,
  }
# exec {
# 'keystonedb':
#   command => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
#   require => Mysql::Db[ $dbname ],
#  } 

}
