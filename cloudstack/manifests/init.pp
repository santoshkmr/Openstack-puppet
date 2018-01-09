class cloudstack (
 $dbpasswd     = $cloudstack::params::dbpasswd,
 $host         = $cloudstack::params::host,
 $softwarepkgs = $cloudstack::params::softwarepkgs,
 $mysqlconf    = $cloudstack::params::mysqlconf,
) inherits cloudstack::params

{
$randomid = generate("/usr/bin/openssl", "rand", "-hex 10")
$pkgs     = $softwarepkgs 

exec {
 'AddRepos':
    timeout     => 0,
    command     => 'apt-get install software-properties-common; add-apt-repository cloud-archive:liberty -y',
    unless      => 'ls -l /etc/apt/sources.list.d/cloudarchive-liberty.list';
 'Update':
    timeout     => 0,
    command     => 'apt-key update; apt-get update; apt-get dist-upgrade -y',
    require     => Exec['AddRepos'],
    subscribe   => Exec['AddRepos'],
    refreshonly => true;
  }
package {
 $pkgs:
    ensure  => present,
    require => [ Exec['AddRepos'], Exec['Update']],
   }
keystone_config
 {
   'DEFAULT/admin_token': value => "${randomid}";
   'token/expiration'   : value => 3600;
   'database/connection': value => "mysql+pymysql://keystone:${dbpasswd}@10.140.2.101/keystone";
   'memcache/servers'   : value => 'localhost:11211';
   'token/provider'     : value => 'uuid';
   'token/driver'       : value => 'memcache';
   'revoke/driver'      : value => 'sql';
   'DEFAULT/verbose'    : value => 'True';
 }
file {
 $mysqlconf:
    ensure      => file,
    owner       => root,
    group       => root,
    mode        => 644,
    source      => 'puppet:///modules/cloudstack/mysqld_openstack.cnf',
    require     => Package[ $pkgs ],
  }
service {
 'mysql':
    ensure      => running,
    enable      => true,
    subscribe   => File [ $mysqlconf ],
  }
exec {
 'rabbitmq':
    command     => 'rabbitmqctl add_user openstack openstack; rabbitmqctl set_permissions openstack ".*" ".*" ".*"',
    require     => Package[ $pkgs ],
    subscribe   => Package[ $pkgs ],
    refreshonly => true,
  }
}
