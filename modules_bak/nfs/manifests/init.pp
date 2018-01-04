class nfs (
 $nfspackages = $nfs::params::nfspackages,
 $service     = $nfs::params::service,
) inherits nfs::params

{
  package {
   $nfspackages:
       ensure => present,
  }
}
