class dirtycow::config {
  notice("dirtycow::config: Do nothing, the apt upgrade just checks if we're defined and blocks apt-get upgrade if so.")

  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $leaked_filenames = $secgen_parameters['leaked_filenames']
  $strings_to_leak = $secgen_parameters['strings_to_leak']


    # Leak a file containing a string/flag to /root/
    ::secgen_functions::leak_files { 'chkrootkit-file-leak':
      storage_directory => '/root',
      leaked_filenames => $leaked_filenames,
      strings_to_leak => $strings_to_leak,
      leaked_from => "chkrootkit_vuln",
      mode => '0600'
    }
}
