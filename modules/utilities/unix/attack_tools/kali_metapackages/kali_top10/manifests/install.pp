class kali_top10::install{
  package { ['kali-tools-top10', 'nfs-common', 'ftp']:
    ensure => 'installed',
  }
}
