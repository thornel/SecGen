define parameterised_accounts::account (
  $username,
  $password,
  $super_user,
  $strings_to_leak,
  $leaked_filenames,
  $data_to_leak = []
) {
  # Add user account

  if $super_user {
    $groups = ['Users','Administrators']
  } else {
    $groups = ['Users']
  }

  user { $username:
    name      => $username,
    ensure    => present,
    groups  => $groups,
    password   => $password,
    managehome => true,
  } ->

  # Leak strings in a text file in the users home directory
  ::secgen_functions::leak_files { "$username-file-leak":
    storage_directory => "C:/Users/$username/Desktop",
    strings_to_leak   => $strings_to_leak,
    leaked_filenames  => $leaked_filenames,
    owner             => $username,
    group             => $username,
    mode              => '0444',
    leaked_from       => "accounts_$username",
  }

  unless $data_to_leak == undef or $data_to_leak == [] or $data_to_leak == [''] {
    ::secgen_functions::leak_data { "$username-data-leak":
      storage_directory => "C:/Users/$username/Desktop",
      data_to_leak      => $data_to_leak,
      owner             => $username,
      group             => $username,
      mode              => '0444',
      leaked_from       => "accounts_$username",
    }
  }
}
