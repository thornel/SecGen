class bludit_upload_images_exec::install {
  # this is where the module starts, as per bludit_upload_images_exec.pp

  # sets the default paths to use
  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  ensure_packages(['php-xml','php-gd','php.mbstring','php-json'])


  # copy and unzip archive
  # note that the file is specified as "source" -- that means the file is copied
  $releasename = 'bludit-3-9-2'
  file { "/usr/local/src/$releasename.zip":
    ensure => file,
    source => "puppet:///modules/bludit_upload_images_exec/$releasename.zip",
  } ->
  exec { 'unpack-bludit':
    cwd => '/usr/local/src',
    command => "unzip $releasename.zip -d /var/www",
    creates => "/var/www/$releasename"
  } ->
  exec { 'chown-bludit':
    command => "chown www-data. /var/www -R",
  }


}
