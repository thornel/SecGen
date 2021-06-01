class xfce_lightdm_root_login::configure {
  case $operatingsystemrelease {
    /^(9|10).*/: { # do 9.x stretch stuff
      file { '/etc/lightdm/lightdm.conf':
        ensure => present,
        source => 'puppet:///modules/xfce_lightdm_root_login/stretch_lightdm.conf',
      }
      file_line { 'lightdm-autologin-remove-pam':
        ensure  => 'present',
        path    => '/etc/pam.d/lightdm-autologin',
        line    => 'auth      required pam_succeed_if.so user != anything quiet_success',
        match   => 'auth      required pam_succeed_if.so user != root quiet_success',
        replace => true,
        match_for_absence => 'false',
      }
    }
    /^7.*/: { # do 7.x wheezy stuff
      exec { 'lightdm-autologin-root':
        command => "/bin/sed -i \'/\\[SeatDefaults\\]/a autologin-user=root\' /etc/lightdm/lightdm.conf"
      }
    }
  }
}
