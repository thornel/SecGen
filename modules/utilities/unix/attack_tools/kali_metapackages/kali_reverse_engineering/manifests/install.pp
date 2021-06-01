class kali_reverse_engineering::install{
  package { ['kali-tools-reverse-engineering']:
    ensure => 'installed',
  }
}
