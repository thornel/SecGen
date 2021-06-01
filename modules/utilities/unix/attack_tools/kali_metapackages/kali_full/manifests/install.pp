class kali_full::install{
  package { ['kali-linux-everything']:
    ensure => 'installed',
  }
}
