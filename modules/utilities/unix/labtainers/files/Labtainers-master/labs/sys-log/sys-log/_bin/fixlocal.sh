#!/bin/bash
#
#  Script will be run after parameterization has completed, e.g., 
#  use this to compile source code that has been parameterized.
#
# avoid error message in syslog
echo $1 | sudo -S touch /dev/xconsole
echo $1 | sudo -S chown syslog:adm /dev/xconsole
