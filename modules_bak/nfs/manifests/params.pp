class nfs::params {

  $nfspackages = hiera('nfspackages')
  $service     = hiera('nfsservices')  
  $nfsvols     = hiera('vols')

}
