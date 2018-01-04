class zabbix::params {

  $zabbix_url             = hiera('zabbix_repo_url')
  $zabbix_repos_file      = hiera('zabbix_repo_file')
  $zabbix_rpm             = hiera('zabbix_repo_rpm')
  $zabbix_pkgs            = hiera('zabbix_packages')
  $zabbix_serverconf_file = '/etc/zabbix/zabbix_server.conf'
  $zabbix_webconf_file    = hiera('webconf')
  $zabbix_logdir          = '/var/log/zabbix'
  $zabbix_logfile         = '/var/log/zabbix/zabbix_server.log'
  $zabbix_piddir          = '/var/run/zabbix'
  $zabbix_pidfile         = '/var/run/zabbix/zabbix_server.pid'
  $zabbix_service         = 'zabbix-server'
  $webservice             = hiera('web')
  $maxconnection          = hiera('dbconn')
  $grant                  = hiera('dbprivileges')
  $dbuser                 = hiera('dbusername')
  $dbpass                 = hiera('dbpassword')
  $dbname                 = hiera('dbasename')
  $privs                  = hiera('privileges')
  $prov                   = hiera('installer')
  $install                = hiera('options')
  $schemafile             = hiera('schema')
}
