class nfs::file (
 $nfspackages = $nfs::params::nfspackages,
 $service     = $nfs::params::service,
 $nfsvols     = $nfs::params::nfsvols,
) inherits nfs::params

{
  file {
    '/etc/exports':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 644,
        require => Package[ $nfspackages ],
        notify  => Service[ $service ],
    } 
  file {
     '/nix':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 744;
      '/nix/volumes_splunk':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 744,
        require => File['/nix'];
     '/nix/volumes_ora':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 744,
        require => File['/nix'];
     '/nix/volumes_cass':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 744,
        require => File['/nix'];
  } 
}
