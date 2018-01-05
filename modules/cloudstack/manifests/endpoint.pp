class cloudstack::endpoint {
#include keystone::disable_admin_token_auth
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
 'stack.com':
    ensure       =>  present,
    enabled      =>  true,
    description  => 'CloudStack and Devops Domain Management',
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
 'devstack::stack.com':
    ensure       =>  present,
    enabled      =>  true,
    description  => 'Cloud Project';
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
 'devopsuser::stack.com':
    ensure   => present,
    enabled  => true,
    email    => 'demo@stack.com';
 }
keystone_role { 
 'admin':
    ensure   => present,
    before   => [Keystone_user_role[ 'cloudadmin@openstack' ], Keystone_user_role[ 'devopsuser@::stack.com']];
 'user':
    ensure   => present,
    before   => [Keystone_user_role[ 'cloudadmin@openstack' ], Keystone_user_role[ 'stackauser@mirantis' ]]; 
 }       
keystone_user_role { 
 'cloudadmin@openstack':
    roles       => ['admin'],
    ensure      => present,
    require     => Keystone_user[ 'cloudadmin' ];
 'stackauser@mirantis':
    roles       => ['user'],
    ensure      => present,
    require     => Keystone_user[ 'stackauser' ];
 'devopsuser@::stack.com':
    roles       => ['admin'],
    ensure      => present,
    user_domain => 'stack.com',
    require     => Keystone_domain[ 'stack.com' ];
 }
} 
