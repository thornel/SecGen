class ircd_hybrid::config {
  service { 'ircd-hybrid':
    enable => true,
    ensure => 'running',
  }
}
