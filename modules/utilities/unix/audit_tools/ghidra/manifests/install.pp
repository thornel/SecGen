class ghidra::install{

  ensure_packages(['openjdk-11-jre', 'openjdk-11-jdk', 'zip' ])

  file { '/opt/ghidra':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/ghidra/release',
    mode   => '0777',
    owner => 'root',
    group => 'root',
  } ->
  file { '/usr/share/applications/ghidra.desktop':
    source => 'puppet:///modules/ghidra/ghidra.desktop',
    mode   => '0644',
    owner => 'root',
    group => 'root',
  }

}
