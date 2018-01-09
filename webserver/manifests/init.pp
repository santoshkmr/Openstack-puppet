class webserver (
 $apache_logdir = $::webserver::params::apache_logdir, 
) inherits webserver::params {
 
class { 
 'apache': 
    default_vhost => false,
 }
apache::vhost { 
 'stack-httpd':
    default_vhost => false,
    port            => 80,
    docroot         => '/var/www/html',
    docroot_mode    => 755,
    logroot         => '/var/log/httpd',
    servername      => 'www.stack.com',
    priority        => false,
    docroot_owner   => apache,
    docroot_group   => apache,
    access_log_file => 'stack.com_access.log',
    error_log_file  => 'stack.com_error.log',
    require         => Class[ 'apache' ];
 'canonical-httpd':
    port            => 80,
    docroot         => '/var/www/html',
    docroot_mode    => 755,
    logroot         => '/var/log/httpd',
    servername      => 'www.canonical.com',
    docroot_owner   => apache,
    docroot_group   => apache,
    access_log_file => 'canonical.com_access.log',
    error_log_file  => 'canonical.com_error.log',
    require         => Class[ 'apache' ],
  }
}
