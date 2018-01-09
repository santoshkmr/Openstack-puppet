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
 '/etc/keystone/keystone-paste.ini':
    ensure  => file,
    mode    => 644,
    owner   => root,
    group   => root,
    require => Package [ $pkgs ];
 }  
#keystone_paste_ini {
# 'pipeline:public_api/pipeline':
#    value => 'sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension user_crud_extension public_service';
# 'pipeline:admin_api/pipeline':
#    value => 'sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension s3_extension crud_extension admin_service';
# 'pipeline:api_v3/pipeline':
#    value => 'sizelimit url_normalize request_id build_auth_context token_auth json_body ec2_extension_v3 s3_extension simple_cert_extension revoke_extension federation_extension oauth1_extension endpoint_filter_extension service_v3';
#}
    
     
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
