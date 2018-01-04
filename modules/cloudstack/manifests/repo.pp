class cloudstack::repo (
 $dbasename  = $cloudstack::params::dbasename,
 $dbpasswd   = $cloudstack::params::dbpasswd,
 $privileges = $cloudstack::params::privileges,
 $dbuser     = $cloudstack::params::dbuser,
 $grant      = $cloudstack::params::grant,

) inherits cloudstack::params

 {
include apt

apt::source { 'mariadb':
  location => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu',
  release  => $::lsbdistcodename,
  repos    => 'main',
  key      => {
    id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
    server => 'hkp://keyserver.ubuntu.com:80',
  },
  include => {
    src   => false,
    deb   => true,
  },
}

class {'::mysql::server':
  package_name     => 'mariadb-server',
#  package_ensure   => '10.1.14+maria-1~trusty',
  service_name     => 'mysql',
  root_password    => 'openstack',
}

Apt::Source['mariadb'] ~> Class['apt::update'] -> Class['::mysql::server']

mysql::db {
  $dbasename:
    user       => $dbuser,
    host       => 'localhost',
    grant      => $grant,
#    before     => [Mysql_grant["${dbuser}@localhost/keystone.*"],Mysql_grant["${dbuser}@%/keystone.*"]],
    before     => Mysql_grant['keystone@localhost/keystone.*'],
    password   => $dbpasswd,
  }
mysql_grant {
  "${dbuser}@localhost/keystone.*":
    ensure     => 'present',
    user       => "${dbuser}@localhost",
    table      => 'keystone.*',
    options    => ['GRANT'],
    privileges => $privileges,
  }
#mysql_grant {
# "${dbuser}@%/keystone.*":
#    ensure     => 'present',
#    user       => "${dbuser}@%",
#    table      => 'keystone.*',
#    options    => ['GRANT'],
#    privileges => $privileges,
#  }

}
