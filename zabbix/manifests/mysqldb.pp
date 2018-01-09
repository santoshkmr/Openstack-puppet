class zabbix::mysqldb (

  $dbuser     = $::zabbix::params::dbuser,
  $dbpass     = $::zabbix::params::dbpass,
  $dbname     = $::zabbix::params::dbname,
  $privs      = $::zabbix::params::privs,
  $grant      = $::zabbix::params::grant,
  $schemafile = $::zabbix::params::schemafile,

) inherits zabbix::params

{

 class { '::mysql_yumrepo':
   } ->
# class { '::mysql::client':}->
 class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts =>  true,
    override_options  => {
                          'mysqld'          => 
                           {
                               'max_connections' => '512'
                           }
                         }
#}
       } -> class { '::mysql::client':}

 mysql::db {
   $dbname:
       user       => "${dbuser}",
       password   => "${dbpass}",
       host       => 'localhost',
       grant      =>  $grant,
       require    =>  [Class['::mysql::server'], Class['::mysql::client']],
       before     =>  Mysql_grant["${dbuser}@localhost/*.*"],
    }
  mysql_grant {
    "${dbuser}@localhost/*.*":
       ensure     => 'present',
       table      => '*.*',
       options    => ['GRANT'],
       privileges => $privs,
       user       => "${dbuser}@localhost",
     }
  file {
    'schema_file':
        name      =>  $schemafile,
        ensure    =>  file,
        owner     => 'root',
        group     => 'root',
        mode      => '644',
        require   =>  Mysql_grant["${dbuser}@localhost/*.*"],
     }
  exec {
     'create_schema':
        command   => "zcat ${schemafile} | /usr/bin/mysql -u ${dbuser} -p${dbpass} ${dbname}",
        unless    => '/usr/bin/mysql -u zabbix -pzabbix zabbix -h localhost -e "select userid from users"',
        require   => File['schema_file'],
     }
}
