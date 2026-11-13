class {'suid_root_vi::change_uid_permissions':
  file_input => {
    '/usr/bin/vi' => '4777',
    '/etc/alternatives/vi' => '4777',
    '/usr/bin/vim.tiny'    => '4777',
    '/usr/bin/vim.basic'    => '4777',
  }
}