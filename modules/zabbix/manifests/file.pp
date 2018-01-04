class zabbix::file (

   $zabbix_logdir          = $zabbix::params::zabbix_logdir,
   $zabbix_logfile         = $zabbix::params::zabbix_logfile,
   $zabbix_pidfile         = $zabbix::params::zabbix_pidfile,
   $zabbix_service         = $zabbix::params::zabbix_service,
   $zabbix_serverconf_file = $zabbix::params::zabbix_serverconf_file,
   $zabbix_webconf_file    = $zabbix::params::zabbix_webconf_file,
   $zabbix_piddir          = $zabbix::params::zabbix_piddir,

) inherits zabbix::params

{ 
  include zabbix::service
  include zabbix::install
  file {
      $zabbix_serverconf_file:
         ensure  => file,
         owner   => root,
         group   => zabbix,
         mode    => 640,
         source  => 'puppet:///modules/zabbix/zabbix_server.conf',
         notify  => Service[$zabbix_service],
         require => Package[$zabbix_pkgs];
      $zabbix_webconf_file:
         ensure  => file,
         owner   => root,
         group   => root,
         mode    => 644,
         source  => 'puppet:///modules/zabbix/zabbix.conf',
         notify  => Service[$webservice],
         require => Package[$zabbix_pkgs];
      $zabbix_logdir:
         ensure  => directory,
         recurse => true,
         owner   => zabbix,
         group   => zabbix,
         mode    => 755,
         require => Package[$zabbix_pkgs];
      $zabbix_logfile:
         ensure  => file,
         recurse => true,
         owner   => zabbix,
         group   => zabbix,
         mode    => 664,
         require => Package[$zabbix_pkgs];
      $zabbix_piddir:
         ensure  => directory,
         recurse => true,
         owner   => zabbix,
         group   => zabbix,
         mode    => 755,
         require => Package[$zabbix_pkgs];
      $zabbix_pidfile:
         ensure  => file,
         recurse => true,
         owner   => zabbix,
         group   => zabbix,
         mode    => 664,
         require => [Package[$zabbix_pkgs], File[$zabbix_piddir]];
    }
}
