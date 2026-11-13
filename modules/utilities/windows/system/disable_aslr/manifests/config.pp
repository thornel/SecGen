class disable_aslr::config {
  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\MoveImages':
      ensure => present,
      type   => dword,
      data   => 00000000,
  }
}
