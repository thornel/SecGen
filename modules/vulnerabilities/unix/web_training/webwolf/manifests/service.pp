class webwolf::service{

  file { '/etc/systemd/system/webwolf.service':
    ensure => 'link',
    target => '/opt/webwolf/webwolf.service',
  }->
  service { 'webwolf':
    ensure   => running,
    enable   => true,
  }
}
