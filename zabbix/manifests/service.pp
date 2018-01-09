class zabbix::service (
  $zabbix_service = $zabbix::params::zabbix_service,
  $webservice     = $zabbix::params::webservice,
) inherits zabbix::params

{
  service {
    $zabbix_service:
      ensure => running,
      enable => true;
    $webservice:
      ensure => running,
      enable => true;
  }
}
