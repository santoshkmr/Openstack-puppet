class openstackids (
 $dbname   = $openstackids::params::dbname,
 $dbpasswd = $openstackids::params::dbpasswd,
 $host     = $openstackids::params::host,

) inherits openstackids::params

{
 include openstackids::mysqldb
 $randomid = generate("/usr/bin/openssl", "rand", "-hex 10")
 $pkgs     = ['keystone', 'python-mysqldb', 'apache2', 'libapache2-mod-wsgi']
 
 exec {
  'update':
     command => 'apt-key update; apt-get update',
     unless  => 'ls -l /etc/keystone/keystone.conf',
     
   }
  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts =>  true,
  } -> class { '::mysql::client':} -> Exec['update']

 package {
   $pkgs:
     ensure  => present,
     require => Exec[ 'update' ],
   }

 keystone_config 
  {
   'token/provider':
       value => 'fernet';
   'DEFAULT/admin_token':
       value => "${randomid}";
   'database/connection':
       value => "mysql://keystone:${dbpasswd}@${host}/keystone";
  }
 exec { 'fernet':
   command => 'keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone',
   require => [ Class ['::mysql::server'], Class ['::mysql::client'], Exec['update']],
 }
}
