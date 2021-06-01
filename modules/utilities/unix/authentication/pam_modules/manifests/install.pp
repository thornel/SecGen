class pam_modules::install{
  package { ['libpam-cracklib', 'libpam-pwquality']:
    ensure => 'installed',
  }
}
