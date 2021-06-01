class webgoat::service{

  file { '/etc/systemd/system/webgoat.service':
    ensure => 'link',
    target => '/opt/webgoat/webgoat.service',
  }->
  service { 'webgoat':
    ensure   => running,
    enable   => true,
  }
}
