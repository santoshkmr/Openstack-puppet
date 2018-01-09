class keystonestack::params {

 $mysqlconf  = hiera('mysqlfile')
 $service    = hiera('mysqlsvc')
 $dbname     = hiera('dbasename')
 $privileges = hiera('privs')
 $dbpasswd   = hiera('password')
 $host       = 'localhost'
 $dbuser     = hiera('dbaseuser')
 $grant      = hiera('grants')
 $idsuser    = hiera('user')
 $idsgroup   = hiera('group')

}
