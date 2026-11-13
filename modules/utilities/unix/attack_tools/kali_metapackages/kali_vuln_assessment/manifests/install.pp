class kali_vuln_assessment::install{
  package { ['kali-tools-vulnerability']:
    ensure => 'installed',
  }
}
