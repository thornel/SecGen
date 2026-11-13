class ncrack_crackable_user_account::init {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  $account = parsejson($secgen_parameters['account'][0])
  $username = $account['username']

  ::ncrack_crackable_user_account::account { "ncrack_crackable_user_account_$username":
    username        => $username,
    password        => $secgen_parameters['password'][0],
    super_user      => str2bool($account['super_user']),
    strings_to_leak => $secgen_parameters['strings_to_leak'],
    leaked_filenames => $secgen_parameters['leaked_filenames']
  }
}