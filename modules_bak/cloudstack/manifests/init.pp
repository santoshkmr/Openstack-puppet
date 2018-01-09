class cloudstack (
$dbpasswd     = $cloudstack::params::dbpasswd,
$host         = $cloudstack::params::host,
$softwarepkgs = $cloudstack::params::softwarepkgs,
) inherits cloudstack::params

{
$randomid = generate("/usr/bin/openssl", "rand", "-hex 10")
$pkgs     = $softwarepkgs 
exec {
 'AddRepos':
   command => 'apt-get install software-properties-common; add-apt-repository cloud-archive:liberty -y',
   timeout => 0,
   unless  => 'ls -l /etc/apt/sources.list.d/cloudarchive-liberty.list',
 }
exec {
 'Update':
   command     => 'apt-key update; apt-get update; apt-get dist-upgrade -y',
   timeout     => 0,
   require     => Exec['AddRepos'],
   subscribe   => Exec['AddRepos'],
   refreshonly => true,
 }
package {
 $pkgs:
    ensure  => present,
    require => [ Exec['AddRepos'], Exec['Update']],
 }
exec {
 'rabbitmq':
   command     => 'rabbitmqctl add_user openstack openstack; rabbitmqctl set_permissions openstack ".*" ".*" ".*"',
   require     => Package[ $pkgs ],
   subscribe   => Package[ $pkgs ],
   refreshonly => true,
 }
keystone_config
 {
   'DEFAULT/admin_token':
       value => "${randomid}";
   'database/connection':
       value => "mysql+pymysql://keystone:${dbpasswd}@10.140.2.101/keystone";
   'memcache/servers':
       value => 'localhost:11211';
   'token/provider':
       value => 'uuid';
   'token/driver':
       value => 'memcache';
   'revoke/driver':
       value => 'sql';
   'DEFAULT/verbose':
       value => 'True';
 }
exec {
 'Remove Keystonedb':
   command => 'rm -f /var/lib/keystone/keystone.db',
   require => Package[ $pkgs ],
   onlyif  => 'ls -l /var/lib/keystone/keystone.db',
 }
}
