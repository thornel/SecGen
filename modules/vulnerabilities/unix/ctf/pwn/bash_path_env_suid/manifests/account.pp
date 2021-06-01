define bash_path_env_suid::account($username, $password, $strings_to_leak, $leaked_filenames) {
  # for template
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  ::accounts::user { $username:
    shell      => '/bin/bash',
    password   => pw_hash($password, 'SHA-512', 'mysalt'),
    managehome => true,
    home_mode  => '0755',
  }

  # Leak strings in a text file in the users home directory
  ::secgen_functions::leak_files { "$username-file-leak":
    storage_directory => "/home/$username/",
    leaked_filenames  => $leaked_filenames,
    strings_to_leak   => $strings_to_leak,
    owner             => $username,
    group             => $username,
    mode              => '0600',
    leaked_from       => "accounts_$username",
  }

  file { "/home/$username/access_my_flag.c":
    owner  => $username,
    group  => $username,
    mode   => '0644',
    ensure => file,
    content => template('bash_path_env_suid/access_my_flag.c.erb'),
  } ->

  exec { "$username-compileandsetup_bash_path_env_suid":
    cwd     => "/home/$username/",
    command => "gcc -o access_my_flag access_my_flag.c && sudo chown $username access_my_flag && sudo chmod 4755 access_my_flag",
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
  }

}
