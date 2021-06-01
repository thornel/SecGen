class before_login_message::init {

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $strings_to_leak = join($secgen_parameters['strings_to_leak'], "\n")

  file_line { "$strings_to_leak leak":
    path => '/etc/issue',
    line => $strings_to_leak,
 }
 file_line { "$strings_to_leak net leak":
    path => '/etc/issue.net',
    line => $strings_to_leak,
 }
}
