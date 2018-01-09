class cloudstack::endpoint {

$randomid = $::cloudstack::randomid

keystone_service { 
 'keystone':
   ensure       =>  present,
   type         => 'identity',
   description  => 'OpenStack Identity Service',
 }
class { 
 'keystone::endpoint':
   public_url   => 'http://10.140.2.101:5000/v2.0',
   admin_url    => 'http://10.140.2.101:35357/v2.0',
   internal_url => 'http://10.140.2.101:5000/v2.0',
   region       => 'RegionOne',
 }
}
