class repos::params {
    $repourl        = hiera('epelurl')  
    $repofile       = hiera('epelfile')
    $repoid         = hiera('EPEL')
    $reponame       = "Extra Packages for Enterprise Linux 7 - \$basearch"
    $metalink       = hiera('link')
    $failovermethod = hiera('method')
    $enabled        = hiera('enable')
    $gpgcheck       = hiera('check')
    $gpgkey         = hiera('key')
}
