class opkeystone::mysqldb (

   $dbname     = $opkeystone::params::dbname,
   $dbpasswd   = $opkeystone::params::passwd,
   $privileges = $opkeystone::params::privileges,   
   $dbuser     = $opkeystone::params::dbuser,
   $grant      = $opkeystone::params::grant,
)inherits opkeystone::params

{
  class { '::mysql::server':
  root_password           => 'strongpassword',
  remove_default_accounts => true,
 } -> class { '::mysql::client':}

mysql::db {
  $dbname:
     user       => $dbuser,
     password   => $dbpasswd,
     host       => 'localhost',
     grant      => $grant,
     require    => [ Class [::mysql::server], Class [::mysql::client] ],
     before     => Mysql_grant["${dbuser}@localhost/*.*"],
   } 
mysql_grant {
  "${dbuser}@localhost/*.*":
     ensure     => present,
     table      => '*.*',
     options    => ['GRANT'],
     privileges => $privileges,
     user       => "${dbuser}@localhost",
   }
#exec {
#  'update':
#     command    => 'apt-key update; apt-get update',
#     before     => [ Class ['::mysql::server'], Class ['::mysql::client'] ],
#   }
}
