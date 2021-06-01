class adobe_utilprintf::install {
  file { 'C:\Users\vagrant\Downloads\AdbeRdr811_en_US.exe':
    ensure => present,
    source => 'puppet:///modules/adobe_utilprintf/AdbeRdr811_en_US.exe',
   } ->

   package { "adobereader811":
     ensure => installed,
     source => 'C:\Users\vagrant\Downloads\AdbeRdr811_en_US.exe',
     install_options => ['/sAll']
   }
   # TODO: delete installer after install
}
