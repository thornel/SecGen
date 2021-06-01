class simple_bof::install {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $buffer_size = 512 #inline_template("<%= (3..8).sample ^ 2 %>")   # randomised buffer size
  $challenge_name = $secgen_parameters['challenge_name'][0]
  $group = $secgen_parameters['group'][0]
  $flag = $secgen_parameters['flag'][0]
  $account = parsejson($secgen_params['account'][0])

  # Parse optional parameters
  if $secgen_params['port'] and $secgen_params['port'][0] {
    $storage_dir = $secgen_params['port'][0]
  } else {
    $storage_dir = 0
  }

  if $secgen_params['storage_directory'] and $secgen_params['storage_directory'][0] {
    $storage_dir = $secgen_params['storage_directory'][0]
  } else {
    $storage_dir = ''
  }

  if $secgen_params['share_dir'] and $secgen_params['share_dir'][0] {
    $share_dir = $secgen_params['share_dir'][0]
  } else {
    $share_dir = ''
  }

  # Generate the C file (either in the home directory or the supplied storage_directory)
  $install_dir = '/root'  # TODO: change me to /tmp after dev (+ retest)
  $c_file_path = "$install_dir/simple_bof.c"
  file { 'simple_bof.c':
    path                    => $c_file_path,
    content                 => template('simple_bof/exploit_me.c.erb'),
    mode                    => '0777',
  }

  # Compile the binary
  ## ... we will need to add compiler parameters to the install_setgid_binary and install_setuid_binary modules
  ##   Determine if want ASLR:
          # OFF: echo 0 > /proc/sys/kernel/randomize_va_space
          # ON:  echo 2 > /proc/sys/kernel/randomize_va_space

  ## Determine if we want executable stack or not:
        # Pass "-z execstack" to gcc to disable

  ## Determine if we want stack canaries or not:
      # Pass "-fno-stack-protector" to gcc to disable canaries


  ## Determine if we want debugging symbols included or not
    # Pass "-g" to gcc to generate debugging symbols

  # SetGID binary requires: Makefile and any .c files within it's <module_name>/files directory
  # Can we dynamically generate these before we call the install_setgid_binary function?

  # TODO: need to make binary_directory work with .c files
  # TODO: need to implement gcc_params within the ::secgen_functions::compile_binary_module function
  # TODO: need to implement running the binary via the network. Consider whether it's better to do this via a separate function within the simple_bof::services puppet file or not. Might not be as clean, as we're calculating the directories etc deeper in the puppet. We could probably do with refactoring this so its not as deep within the puppet though.
  # TODO: (optional) need to refactor the install_setuid_root_binary to use the compile_binary_module function

   ::secgen_functions::install_setgid_binary { "simple_bof_$challenge_name":
    source_module_name => 'simple_bof',
    challenge_name     => $challenge_name,
    c_file             => $c_file_path,
    gcc_params         => '-z execstack -z norelro -no-pie -fno-pie -m32',
    group              => $group,
    account            => $account,
    flag               => $flag,
    flag_name          => 'flag',
    port               => $port,
    storage_dir        => $storage_dir,
    share_dir          => $share_dir,
   }
}
