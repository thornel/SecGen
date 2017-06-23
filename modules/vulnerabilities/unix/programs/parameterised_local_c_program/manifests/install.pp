class parameterised_local_c_program::install {

	$json_inputs = base64('decode', $::base64_inputs)
	$secgen_parameters = parsejson($json_inputs)
	$code = parsejson($secgen_parameters['code'][0])

	# Create new directory to clean up	
	file { '/opt/code':
		ensure => 'directory',
  	}	
	
	# Copy the code to the VM
	file { "/opt/code/c_code.c":
		ensure => file,
		content => template('parameterised_local_c_program/c_code.c.erb')
	}

	file { "/opt/code/c_code_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/c_code_helper.c')
	}
	
	file { "/opt/code/authentication_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/authentication_helper.c.erb')
	}

	file { "/opt/code/notes.c":
		ensure => file,
		content => template('parameterised_local_c_program/notes.c')
	}

	file { "/opt/code/notes_helper.c":
		ensure => file,
		content => template('parameterised_local_c_program/notes_helper.c')
	}

	# Compile the code on the VM
	exec { "compile /opt/code":
		command => "gcc c_code.c -o c_code -fno-stack-protector",
		cwd => "/opt/code",
		path =>  [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]
	}
	
	# Move the compiled code
	exec { "move /opt/code":
		command => "cp c_code /opt/c_code",
		cwd => "/opt/code",
		path =>  [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]
	}
	
	# Cleanup
	#exec { 'directory-cleanup':
	#	command => 'rm -r code',
	#	cwd => "/opt",
	#	path =>  [ '/bin/' ]
	#}

}


