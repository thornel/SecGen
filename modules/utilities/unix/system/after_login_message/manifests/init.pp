class after_login_message::init {

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $strings_to_leak = join($secgen_parameters['strings_to_leak'], "\n")

  file_line { "$strings_to_leak leak login":
    path => '/etc/bash.bashrc',
    line => "cat <<'EOF'\n$strings_to_leak\nEOF",
  }

}
