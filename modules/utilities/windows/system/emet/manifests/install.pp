class emet::install {
  package { 'emet':
    provider => chocolatey,
    ensure => installed,
  }
}
