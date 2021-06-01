class groups::init {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  $groups = $secgen_parameters['groups']
  if $groups {
    $groups.each |$group| {

      group { "$group":
        ensure => 'present',
      }
    }
  }
}
