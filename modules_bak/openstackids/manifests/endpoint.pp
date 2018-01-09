class openstackids::endpoint {

include openstackids

class { 'keystone::roles::admin':
  email        => 'admin@stack.com',
  password     => 'strongpassword',
}

class { 'keystone::endpoint':
  public_url   => 'http://10.140.2.152:5000/v2.0',
  admin_url    => 'http://10.140.2.152:35357/v2.0',
  internal_url => 'http://10.140.2.152:5000/v2.0',
  region       => 'BKL-DC1',
  require      => Exec ['fernet'],
}

}
