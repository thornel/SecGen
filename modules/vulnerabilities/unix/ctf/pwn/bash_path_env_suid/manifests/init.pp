class bash_path_env_suid::init {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  $accounts = $secgen_parameters['accounts']
  $accounts.each |$raw_account| {
    $account  = parsejson($raw_account)
    $username = $account['username']
    bash_path_env_suid::account { "bash_path_env_suid_$username":
      username         => $username,
      password         => $account['password'],
      strings_to_leak  => $account['strings_to_leak'],
      leaked_filenames => $account['leaked_filenames']
    }
  }
}
