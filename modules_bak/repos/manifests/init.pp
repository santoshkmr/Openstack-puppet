class repos (

   $repoid         = $repos::params::repoid,
   $metalink       = $repos::params::metalink,
   $failovermethod = $repos::params::failovermethod,
   $enabled        = $repos::params::enabled,
   $gpgcheck       = $repos::params::gpgcheck,
   $gpgkey         = $repos::params::gpgkey,
   $repourl        = $repos::params::repourl,
   $repofile       = $repos::params::repofile,

)inherits repos::params 

{
  include wget
  
  wget::fetch {
    'Centos-7 repo download':
      source         => $repourl,
      destination    => "/tmp/${repofile}",
      timeout        => 0,
      verbose        => false,
    }
  file {
    "/tmp/${repofile}":
      ensure         => file,
      owner          => root,
      group          => root,
      mode           => 644,
      require        => Wget::Fetch['Centos-7 repo download'],
      before         => Yumrepo[ $repoid ],
   }
  yumrepo {
    "${repoid}":
      enabled        => $enabled,
      descr          => $reponame,
      metalink       => $metalink,
      failovermethod => $failovermethod,
      gpgcheck       => $gpgcheck,
      gpgkey         => $gpgkey,
    }
  exec { 
    'List Repos':
      command        => 'yum repolist',
      require        => Yumrepo[ $repoid ],
    }   
}
