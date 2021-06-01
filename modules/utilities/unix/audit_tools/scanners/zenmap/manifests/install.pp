class zenmap::install {
  package { 'zenmap':
    ensure => installed,
  }
}
