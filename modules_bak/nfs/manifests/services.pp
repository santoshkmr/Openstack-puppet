class nfs::services (
  $service = $nfs::params::service,
) inherits nfs::params

{
   service {
    $service:
       ensure  => running,
       enable  => true,
       require => Package[ $nfspackages ], 
  }
}
