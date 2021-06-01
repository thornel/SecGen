class proftpd_133c_backdoor::config {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $raw_org = $secgen_parameters['organisation']
  $leaked_filenames = $secgen_parameters['leaked_filenames']
  $strings_to_leak = $secgen_parameters['strings_to_leak']

  if $raw_org and $raw_org[0] and $raw_org[0] != '' {
    $organisation = parsejson($raw_org[0])
  } else {
    $organisation = ''
  }
    file { '/etc/proftpd/proftpd.conf':
    ensure   => present,
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    content  => template('proftpd_133c_backdoor/proftpd.erb')
  }

  ::secgen_functions::leak_files { 'proftpd_133c_backdoor-file-leak':
    storage_directory => '/root',
    leaked_filenames  => $leaked_filenames,
    strings_to_leak   => $strings_to_leak,
    leaked_from       => "proftpd_133c_backdoor",
    mode              => '0600'
  }
}
