class openstackids::mysqldb (
   $dbname     = $openstackids::params::dbname,
   $dbpasswd   = $openstackids::params::dbpasswd,
   $privileges = $openstackids::params::privileges,
   $dbuser     = $openstackids::params::dbuser,
   $grant      = $openstackids::params::grant,
) inherits openstackids::params
{
 include openstackids
# class { '::mysql::server':
#    root_password           => 'strongpassword',
#    remove_default_accounts =>  true,
#  } -> class { '::mysql::client':} -> Exec['update']

 mysql::db {
   $dbname:
       user       => $dbuser,
       password   => $dbpasswd,
       host       => 'localhost',
       grant      => $grant,
       require    => [Class['::mysql::server'], Class['::mysql::client'], Exec['update']],
       before     => [Mysql_grant["${dbuser}@localhost/*.*"],Mysql_grant["${dbuser}@%/*.*"]],
    }
 mysql_grant {
    "${dbuser}@localhost/*.*":
       ensure     => 'present',
       table      => '*.*',
       options    => ['GRANT'],
       privileges => $privileges,
       user       => "${dbuser}@localhost",
    }
 mysql_grant {
    "${dbuser}@%/*.*":
       ensure     => 'present',
       table      => '*.*',
       options    => ['GRANT'],
       privileges => $privileges,
       user       => "${dbuser}@%",
    }
 exec {
   'keystonedb':
       command    => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
       require    => [Mysql_grant["${dbuser}@localhost/*.*"], Mysql_grant["${dbuser}@%/*.*"]],
#       unless     => "mysql -u ${dbuser} -p${dbpasswd} -e 'show tables' ${dbname}",
   }
}
