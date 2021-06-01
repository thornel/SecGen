class suid_root_nano::config {
  file { '/bin/nano':
    mode => "4755",
    owner => "root",
  }
  file { '/usr/bin/nano':
    mode => "4755",
    owner => "root",
  }
}
