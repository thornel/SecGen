class {'suid_root_less::change_uid_permissions':
  user => 'root',
  file_input => {
    '/bin/less' => '4777',
    '/usr/bin/less' => '4777',
  },
}
