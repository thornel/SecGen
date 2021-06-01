#!/usr/bin/env bash

# precheck.sh
# Description:
#     This file should contain checks for local settings (such as sysctl)
#     specific for each lab.  The resulting output will go into the
#     precheck.stdout.timestamp file
#
# Run nmap on port 2023 - the 'other' telnet
nmap -n -p2023 172.25.0.3
