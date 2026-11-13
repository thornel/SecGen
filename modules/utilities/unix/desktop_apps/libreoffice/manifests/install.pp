class libreoffice::install{
  package { 'libreoffice-writer':
    ensure => 'installed',
  }
  package { 'libreoffice-calc':
    ensure => 'installed',
  }
}
