class opkeystone::files (
 $dbpasswd = $opkeystone::params::dbpasswd
) inherits opkeystone::params

{
 class { 'keystone':
   admin_token         => 'random_uuid',
    }

# exec {
#   'update':
#     command => 'apt-key update; apt-get update',
#     before  => Class ['keystone'],
#  }

class keystone::db {
   keystone_config { 
     'database/connection':
        value      => "mysql+pymysql://keystone:${dbpasswd}@${::fqdn}/keystone";
     }
  }
}
