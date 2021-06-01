class nc_backdoor_chroot_esc::service{
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $port = $secgen_parameters['port'][0]

  file { '/opt/chroot.service':
    ensure => file,
    content => template( 'nc_backdoor_chroot_esc/chroot.service.erb'),
  } ->
  file { '/etc/systemd/system/chroot.service':
    ensure => 'link',
    target => '/opt/chroot.service',
  } ->
  service { 'chroot':
    ensure   => running,
    enable   => true,
  }


}
