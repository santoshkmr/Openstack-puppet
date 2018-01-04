class cloudstack::files(
 $mysqlconf = $cloudstack::params::mysqlconf,
)inherits cloudstack::params

{
$pkgs = $cloudstack::pkgs
include cloudstack
file {
 '/etc/init/keystone.override':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    require => Package[ $pkgs ],
  } 
file {
 '/etc/apache2/apache2.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/cloudstack/apache2.conf',
    require => Package[ $pkgs ];
 '/etc/apache2/sites-available/wsgi-keystone.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/cloudstack/wsgi-keystone.conf',
    require => Package[ $pkgs ];
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
}
