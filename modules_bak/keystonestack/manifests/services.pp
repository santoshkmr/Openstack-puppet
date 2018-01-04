class keystonestack::services (
$service = $keystonestack::params::service,
) inherits keystonestack::params

{
 service {
   $service:
     ensure  => running,
     enable  => true,
 }
}
