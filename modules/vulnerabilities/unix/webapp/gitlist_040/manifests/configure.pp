class gitlist_040::configure {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $leaked_filenames = $secgen_parameters['leaked_filenames']
  $strings_to_leak = $secgen_parameters['strings_to_leak']
  $images_to_leak = $secgen_parameters['images_to_leak']
  $leaked_files_path = '/home/git/repositories/secret_files'

  # when there are multiple strings to leak:
  #   leak the first one as a flag, requiring exploitation to access;
  #   leak the subsequent ones publically through the website;

  if $strings_to_leak.length == 0 {
    warning('No strings_to_leak provided!')
  } elsif $strings_to_leak.length == 1 {
    warning("Only one string to leak provided, publically showing a default message.")

    $flag = [$strings_to_leak[0]]
    $flag_filename = [$leaked_filenames[0]]

    $public_strings_to_leak = ["Nothing to see here."]
    $public_strings_to_leak_filename = $leaked_filenames[1, -1]
  } else { # more than 1 strings_to_leak
    warning("One string to leak will require exploitation, others will be publically shown.")
    $flag = [$strings_to_leak[0]]
    $flag_filename = [$leaked_filenames[0]]

    # all but the first elements (used above already)
    $public_strings_to_leak = $strings_to_leak[1, -1]
    $public_strings_to_leak_filename = $leaked_filenames[1, -1]
  }


  $git_args = '-c user.name="gitlist" -c user.email="git@list.com"'

  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  # Create /home/git/repositories
  file { ['/home/git', '/home/git/repositories']:
    ensure => directory,
    owner  => 'www-data',
  }

  file { $leaked_files_path:
    ensure => directory,
    before => Exec['create-repo-file_leak']
  } ->

  exec { 'create-repo-file_leak':
    cwd     => $leaked_files_path,
    command => "git init",
  } ->

  file { "$leaked_files_path/.git/description":
    content => "secret_files"
  }

  ::secgen_functions::leak_files { 'gitlist_040-flag-leak':
    storage_directory => '/home/git',
    leaked_filenames  => $flag_filename,
    strings_to_leak   => $flag,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  ::secgen_functions::leak_files { 'gitlist_040-file-leak':
    storage_directory => $leaked_files_path,
    leaked_filenames  => $public_strings_to_leak_filename,
    strings_to_leak   => $public_strings_to_leak,
    images_to_leak    => $images_to_leak,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  exec { 'initial_commit_leaked_files_repo':
    cwd     => $leaked_files_path,
    command => "git $git_args add *; git $git_args commit -a -m 'initial commit'",
  }
}
