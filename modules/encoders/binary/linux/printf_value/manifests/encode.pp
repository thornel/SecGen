class printf::build{

  file { '/tmp/c.c':
    owner  => root,
    group  => root,
    mode   => '0775',
    ensure => file,
    content  => template('c.c.erb')
    notify => Exec['build'],
  }

  exec { 'build':
    cwd     => '/tmp',
    command => 'gcc c.c -o binary.out',
    creates => '/tmp/binary.out',
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
#    notify  => Exec['install_proftpd-1.3.3c'],
  }


}