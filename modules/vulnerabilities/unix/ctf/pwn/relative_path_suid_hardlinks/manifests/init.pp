class relative_path_suid_hardlinks::init {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  $accounts = $secgen_parameters['accounts']
  $accounts.each |$raw_account| {
    $account  = parsejson($raw_account)
    $username = $account['username']
    relative_path_suid_hardlinks::account { "relative_path_suid_hardlinks_$username":
      username         => $username,
      password         => $account['password'],
      strings_to_leak  => $account['strings_to_leak'],
      leaked_filenames => $account['leaked_filenames']
    }
  }
}
