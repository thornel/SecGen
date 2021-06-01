class apt_upgrade::apt {

  notice("Running apt-upgrade module...")

  if defined('dirtycow::config') {
    notice("vulnerabilities/unix/local/dirtycow included - skipping apt-get upgrade...")
  } else {
    case $operatingsystem {
      'Debian': {
        # can't upgrade puppet agent mid-provision or it breaks on oVirt.
        exec { 'hold puppet-agent':
          command => '/usr/bin/apt-mark hold puppet-agent'
        }
        exec { 'update':
          command   => "/usr/bin/apt-get -y upgrade",
          tries     => 5,
          try_sleep => 30,
          timeout => 0,
          logoutput   => true,
          require => Exec['hold puppet-agent'],
        }
      }
      'Ubuntu': {
        exec { 'update':
          command   => "/usr/bin/apt-get -y upgrade",
          tries     => 5,
          try_sleep => 30,
          timeout => 0,
          logoutput   => true,
        }
      }
    }
  }
}
