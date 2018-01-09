class opkeystone::params {

  $dbname     = hiera('dbasename')
  $privileges = hiera('privs')
  $dbpasswd   = hiera('password')
  $host       = 'localhost'
  $dbuser     = hiera('user')
  $grant      = hiera('grants')
}
