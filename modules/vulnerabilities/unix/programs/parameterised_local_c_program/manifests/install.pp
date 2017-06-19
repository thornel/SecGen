class parameterised_local_c_program::install {

	$json_inputs = base64('decode', $::base64_inputs)
	$secgen_parameters = parsejson($json_inputs)
	$code = parsejson($secgen_parameters['code'][0])

	# Create new directory to clean up	
	file { '/tmp/code':
		ensure => 'directory',
  	}	
	
	# Copy the code to the VM
	file { "/tmp/code/c_code.c":
		ensure => file,
		content => template('parameterised_local_c_program/c_code.c.erb')
	}

	file { "/tmp/code/c_code_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/c_code_helper.c')
	}
	
	file { "/tmp/code/authentication_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/authentication_helper.c.erb')
	}

	file { "/tmp/code/notes.c":
		ensure => file,
		content => template('parameterised_local_c_program/notes.c')
	}

	file { "/tmp/code/notes_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/notes_helper.c')
	}

	# Compile the code on the VM
	exec { "compile /tmp/code":
		command => "gcc c_code.c -o c_code -fno-stack-protector",
		cwd => "/tmp/code",
		path =>  [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]
	}
	
	# Move the compiled code
	exec { "move /tmp/code":
		command => "cp c_code /tmp/c_code",
		cwd => "/tmp/code",
		path =>  [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]
	}
	
	# Cleanup
	exec { 'directory-cleanup':
		command => 'rm -r code',
		cwd => "/tmp",
		path =>  [ '/bin/' ]
	}

}


