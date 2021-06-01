class parameterised_accounts::init {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $accounts = $secgen_parameters['accounts']

  local_security_policy {  'Password must meet complexity requirements':
    ensure => present,
    policy_value => 'Disabled',
  }

  if $accounts {
    notice($accounts)
    $accounts.each |$raw_account| {
      $account = parsejson($raw_account)
      $username = $account['username']
      parameterised_accounts::account { "parameterised_$username":
        username        => $username,
        password        => $account['password'],
        super_user      => str2bool($account['super_user']),
        strings_to_leak => $account['strings_to_leak'],
        leaked_filenames => $account['leaked_filenames'],
        data_to_leak    => $account['data_to_leak'],
      }
    }
  }


}
