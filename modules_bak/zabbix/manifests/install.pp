class zabbix::install (
  $zabbix_url        = $::zabbix::params::zabbix_url,
  $zabbix_repos_file = $::zabbix::params::zabbix_repos_file,
  $zabbix_rpm        = $::zabbix::params::zabbix_rpm,
  $zabbix_pkgs       = $::zabbix::params::zabbix_pkgs,
  $prov              = $::zabbix::params::prov,
  $install           = $::zabbix::params::install,
  $schemafile        = $::zabbix::params::schemafile,

)inherits zabbix::params

{
 include wget
 include zabbix::mysqldb
 wget::fetch {
   'Zabbix repo download':
      source      => "${zabbix_url}",
      destination => "/tmp/${zabbix_repos_file}",
      timeout     => 0,
      verbose     => false,
      before      => Package[$::zabbix::params::zabbix_rpm],
    }
 package {
    $::zabbix::params::zabbix_rpm:
      provider        => $prov,
      install_options => [ $install ],
      source          => "/tmp/${zabbix_repos_file}",
      ensure          => installed,
    }
 if $::osfamily == 'Debian' {
     exec {'update':
      command         => 'apt-key update; apt-get update',
      require         => Package[ $::zabbix::params::zabbix_rpm ],
   }
 }
 package {
    $zabbix_pkgs:
      ensure  => installed,
      before  => File['schema_file'],
      require => Package[$::zabbix::params::zabbix_rpm],
    }
}
