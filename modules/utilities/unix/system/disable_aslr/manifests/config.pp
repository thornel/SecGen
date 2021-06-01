class disable_aslr::config {

  file { '/etc/sysctl.d/01-disable-aslr.conf':
    content => 'kernel.randomize_va_space = 0',
  }
}
