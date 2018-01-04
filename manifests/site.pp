node 'zabx.stack.com', 'cloud.stack.com' {
 
 include wget
 include zabbix::params
 include zabbix::mysqldb
 include zabbix
 include zabbix::install
 include zabbix::file
 include zabbix::service
 include repos::params
 include repos
 Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }
 include nfs::params
 include nfs
 include nfs::services
 include nfs::file
}
node 'openstack.stack.com', 'canonical.stack.com' {
 Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }
 include cloudstack::params
 include cloudstack
 include cloudstack::mysqldb
# include cloudstack::files
 include cloudstack::endpoint
} 
