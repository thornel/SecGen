class dns_tools::install {
  # standard dns tools, such as dig
  package { ['dnsutils', 'dnstracer']:
    ensure => installed,
  }

  # when on kali, install extra dns enum tools
  if $facts['os']['distro']['codename'] == 'kali-rolling' {
    package { ['dnsenum', 'dnsmap', 'dnsrecon', 'fierce']:
      ensure => installed,
    }
  }

  # enable using a dns server to resolve host names
  file_line { 'resolve_hosts_with_dns':
    path  => '/etc/nsswitch.conf',
    line  => 'hosts:          files dns',
    match => '^hosts.*files.*$',
  }
}
