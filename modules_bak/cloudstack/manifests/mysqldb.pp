class cloudstack::mysqldb (
 $dbasename  = $cloudstack::params::dbasename,
 $dbpasswd   = $cloudstack::params::dbpasswd,
 $privileges = $cloudstack::params::privileges,
 $dbuser     = $cloudstack::params::dbuser,
 $grant      = $cloudstack::params::grant,
 $mysqlconf  = $cloudstack::params::mysqlconf,
 
) inherits cloudstack::params

{
$pkgs = $cloudstack::pkgs 
mysql::db {
  $dbasename:
    user       => $dbuser,
    host       => 'localhost',
    grant      => $grant,
    before     => [Mysql_grant["${dbuser}@localhost/keystone.*"],Mysql_grant["${dbuser}@%/keystone.*"]],
    password   => $dbpasswd,
    require    => Package[ $pkgs ],
  }
mysql_grant {
  "${dbuser}@localhost/keystone.*":
    ensure     => 'present',
    user       => "${dbuser}@localhost",
    table      => 'keystone.*',
    options    => ['GRANT'],
    privileges => 'ALL',
  }
mysql_grant {
 "${dbuser}@%/keystone.*":
    ensure     => 'present',
    user       => "${dbuser}@%",
    table      => 'keystone.*',
    options    => ['GRANT'],
    privileges => 'ALL',
  }

file {
 $mysqlconf:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/cloudstack/mysqld_openstack.cnf',
    require => Package[ $pkgs ],
 }

exec {
 'svcrestart':
    command     => 'service mysql restart',
    subscribe   => File[ $mysqlconf ],
    refreshonly => true,
  }
#exec {
# 'keystonedb':
#   command => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
#   require => [ Mysql::Db[ $dbasename ], File[ $mysqlconf ]],
#  } 
}
