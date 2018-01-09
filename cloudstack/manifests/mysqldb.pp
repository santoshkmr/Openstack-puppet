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

file {
 '/etc/init/keystone.override':
    ensure => file,
    mode   => 644,
    owner  => root,
    group  => root,
    before => Package[ $pkgs ],
  }
exec {
  'KeystoneStop':
    command => 'echo "manual" > /etc/init/keystone.override',
    unless  => 'grep manual /etc/init/keystone.override',
    require =>  File[ '/etc/init/keystone.override' ],
 }
mysql::db {
  $dbasename:
    user       => $dbuser,
    host       => '%',
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
    before     => Exec[ 'keystonedb' ],
  }
mysql_grant {
 "${dbuser}@%/keystone.*":
    ensure     => 'present',
    user       => "${dbuser}@%",
    table      => 'keystone.*',
    options    => ['GRANT'],
    privileges => 'ALL',
    before     => Exec[ 'keystonedb' ],
  }
exec {
 'keystonedb':
   command => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
   require => [ Mysql::Db[ $dbasename ], File[ $mysqlconf ]],
  } 
}
