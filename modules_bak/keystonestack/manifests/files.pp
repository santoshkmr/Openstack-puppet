class keystonestack::files(
 $mysqlconf = $keystonestack::params::mysqlconf,
)inherits keystonestack::params

{
include keystonestack
file {
 $mysqlconf:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/keystonestack/mysqld_openstack.cnf',
 }
file {
 '/etc/init/keystone.override':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
  } 
file {
 '/etc/apache2/apache2.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/keystonestack/apache2.conf';
 '/etc/apache2/sites-available/wsgi-keystone.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/keystonestack/wsgi-keystone.conf';
 }
file {
 '/etc/apache2/sites-enabled/wsgi-keystone.conf':
    ensure  => link,
    owner   => root,
    group   => root,
    target  => '/etc/apache2/sites-available/wsgi-keystone.conf',
    require => [ File ['/etc/apache2/apache2.conf'], File ['/etc/apache2/sites-available/wsgi-keystone.conf'] ],
 }  
exec {
 'Apache2 restart':
    command     => 'service apache2 restart',
    subscribe   => [ File ['/etc/apache2/apache2.conf'], File ['/etc/apache2/sites-available/wsgi-keystone.conf'] ],
    refreshonly => true,
 }
exec {
 'keystonefile':
    command => 'echo "manual" > /etc/init/keystone.override',
    require => File[ '/etc/init/keystone.override' ],
    unless  => 'grep manual /etc/init/keystone.override',
  }
exec {
 'svcrestart':
    command     => 'service mysql restart',
    subscribe   => File[ $mysqlconf ],
    refreshonly => true,
  }
}
