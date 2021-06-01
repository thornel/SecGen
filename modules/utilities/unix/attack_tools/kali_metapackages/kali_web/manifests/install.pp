class kali_web::install{
  package { ['kali-tools-web']:
    ensure => 'installed',
  }
}
