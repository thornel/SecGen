class crackable_user_account::init {
  $json_inputs = base64('decode', $::base64_inputs)
  $secgen_parameters = parsejson($json_inputs)

  $account = parsejson($secgen_parameters['accounts'][0])
  $username = $account['username']

  ::accounts::user { "crackable_user_account_$username":
    name        => $username,
    password    => pw_hash($account['password'], 'SHA-512', 'mysalt'),
  }
}