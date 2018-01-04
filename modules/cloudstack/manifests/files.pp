class cloudstack::files(
 $mysqlconf = $cloudstack::params::mysqlconf,
)inherits cloudstack::params

{
$pkgs     = $::cloudstack::pkgs
$randomid = $::cloudstack::randomid
include cloudstack
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
 '/etc/apache2/sites-enabled/wsgi-keystone.conf':
    ensure  => link,
    owner   => root,
    group   => root,
    target  => '/etc/apache2/sites-available/wsgi-keystone.conf',
    require => [ File ['/etc/apache2/apache2.conf'], File ['/etc/apache2/sites-available/wsgi-keystone.conf'] ];
 '/root/openrc':
    ensure  => file,
    mode    => 644,
    owner   => root,
    group   => root,
    content => template('cloudstack/openrc.erb');
 }  
exec {
 'Apache2 restart':
    timeout     => 0,
    command     => 'service apache2 restart',
    subscribe   => [ File ['/etc/apache2/apache2.conf'], File ['/etc/apache2/sites-available/wsgi-keystone.conf'] ],
    refreshonly => true;
 'keystonefiledel':
    command => 'rm -f /var/lib/keystone/keystone.db',
    require =>  Package[ $pkgs ],
    onlyif  => 'ls -l /var/lib/keystone/keystone.db';
 'sourceopenrc':
    command => "bash -c 'source /root/openrc'",
    require => [File[ '/root/openrc'], Keystone_config[ 'DEFAULT/admin_token']];
  }
}
