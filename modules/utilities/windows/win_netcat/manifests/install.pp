class win_netcat::install {
  file { 'C:\Windows\System32\nc.exe':
    ensure => present,
    source => 'puppet:///modules/win_netcat/nc.exe',
   }
}
