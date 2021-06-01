class suid_root_nano::install {
  package { 'nano':
    ensure => installed
  }
}
