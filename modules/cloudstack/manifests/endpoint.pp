class cloudstack::endpoint {

$randomid = $::cloudstack::randomid
keystone_service { 
 'keystone':
    ensure       =>  present,
    type         => 'identity',
    description  => 'OpenStack Identity Service',
    before       =>  Class[ 'keystone::endpoint' ],
  }
class { 
 'keystone::endpoint':
    public_url   => 'http://10.140.2.101:5000/v2.0',
    admin_url    => 'http://10.140.2.101:35357/v2.0',
    internal_url => 'http://10.140.2.101:5000/v2.0',
    region       => 'RegionOne',
 }
keystone_domain {
 'cloud_domain':
    name         => 'stack.com',
    ensure       =>  present,
    enabled      =>  true,
    description  => 'Cloud Domain Management',
 }   
keystone_tenant {
 'openstack':
    ensure       =>  present,
    enabled      =>  true,
    description  => 'Stack Project';
 'susecloud':
    ensure       =>  present,
    enabled      =>  true,
    description  => 'Suse Project';
 'mirantis':
    ensure       =>  present,
    enabled      =>  true,
    description  => 'Cloud Project';
 'devstack':
    ensure       =>  present,
    enabled      =>  true,
    domain       => 'stack.com',
    description  => 'Devops Project';
 }
keystone_user {
 'cloudadmin':
    ensure   => present,
    enabled  => true,
    email    => 'admin@stack.com';
 'suseadmin':
    ensure   => present,
    enabled  => true,
    email    => 'service@stack.com';
 'stackauser':
    ensure   => present,
    enabled  => true,
    email    => 'demo@stack.com';
 'devopsuser':
    ensure   => present,
    enabled  => true,
    domain   => 'stack.com',
    email    => 'demo@stack.com';
 }
keystone_role { 
 'admin':
    ensure   => present,
    before   => [Keystone_user_role[ 'cloudadmin@openstack' ], Keystone_user_role[ 'devopsuser@devstack' ]];
 'user':
    ensure   => present,
    before   => [Keystone_user_role[ 'cloudadmin@openstack' ], Keystone_user_role[ 'stackauser@mirantis' ]]; 
 }       
keystone_user_role { 
 'cloudadmin@openstack':
    roles    => ['admin'],
    ensure   => present,
    require  => Keystone_user[ 'cloudadmin' ];
 'stackauser@mirantis':
    roles    => ['user'],
    ensure   => present,
    require  => Keystone_user[ 'stackauser' ];
 'devopsuser@devstack':
    roles    => ['admin'],
    ensure   => present,
    require  => Keystone_user[ 'devopsuser' ];
 }
} 
