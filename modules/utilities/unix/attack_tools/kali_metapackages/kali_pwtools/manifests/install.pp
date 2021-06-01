class kali_pwtools::install{
  package { ['kali-tools-passwords']:
    ensure => 'installed',
  }
}
