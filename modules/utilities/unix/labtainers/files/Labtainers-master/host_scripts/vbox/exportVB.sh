#!/bin/bash
rm LabtainerVM-VirtualBox.ova
vboxmanage export "Labtainer VM" -o LabtainerVM-VirtualBox.ova
vboxmanage unregistervm LabtainerVM-test --delete
vboxmanage import LabtainerVM-VirtualBox.ova --vsys 0 --vmname LabtainerVM-test
vboxmanage startvm "LabtainerVM-test"
