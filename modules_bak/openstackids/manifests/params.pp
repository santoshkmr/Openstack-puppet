class openstackids::params {
  $dbname     = hiera('dbasename')
  $privileges = hiera('privs')
  $dbpasswd   = hiera('password')
  $host       = 'localhost'
  $dbuser     = hiera('user')
  $grant      = hiera('grants')
  $idsuser    = hiera('user')
  $idsgroup   = hiera('group')
}
