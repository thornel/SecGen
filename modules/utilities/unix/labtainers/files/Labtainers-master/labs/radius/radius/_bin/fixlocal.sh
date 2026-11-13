#!/bin/bash
#
#  Script will be run after parameterization has completed, e.g., 
#  use this to compile source code that has been parameterized.
#  The container user password will be passed as the first argument.
#  Thus, if this script is to use sudo and the sudoers for the lab
#  not not permit nopassword, then use:
#  echo $1 | sudo -S the-command
#
sudo tee -a /etc/raddb/clients.conf << EOT
client controller1 {
        ipaddr = 172.25.0.10
        secret = testing123
}
EOT

sudo sudo tee -a /etc/raddb/users << EOT

cadmin     Cleartext-Password := "hardcoded_password"
        Reply-Message := "Hello, %{User-Name}"

EOT
