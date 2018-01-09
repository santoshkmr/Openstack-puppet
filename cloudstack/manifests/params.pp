class cloudstack::params {

 $mysqlconf    = hiera('mysqlfile')
 $service      = hiera('mysqlsvc')
 $dbasename    = hiera('databname')
 $privileges   = hiera('privs')
 $dbpasswd     = hiera('password')
 $host         = 'localhost'
 $dbuser       = hiera('dbaseuser')
 $grant        = hiera('grants')
 $idsuser      = hiera('user')
 $idsgroup     = hiera('group')
 $softwarepkgs = hiera('softwarepkgs')
}
