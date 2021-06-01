class kali_forensic::install{
  package { ['kali-tools-forensics']:
    ensure => 'installed',
  }
}
