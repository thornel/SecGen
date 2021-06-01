#!/bin/bash
#
# Create a master Labtainer image for use in running Labtainers from a container
# on any system that has Docker installed, withou having to install Labtainers.
# Thanks for Olivier Berger for this contribution.
#
source ./set_reg.sh
if [[ "$1" != -f ]]; then
   echo "This will build the labtainer master controller image.  "
   echo "registry is $LABTAINER_REGISTRY"
   read -p "Continue? (y/n)"
   if [[ ! $REPLY =~ ^[Yy]$ ]]
   then
       echo exiting
       exit
   fi
else
   echo "registry is $LABTAINER_REGISTRY"
fi
here=`pwd`
cd ../
cp ../../distrib/labtainer.tar ./

cat <<EOT >bashrc.labtainer.master
   if [[ ":\$PATH:" != *":./bin:"* ]]; then 
       export PATH="\${PATH}:./bin:/home/labtainer/labtainer/trunk/scripts/designer/bin"
       export LABTAINER_DIR=/home/labtainer/labtainer/trunk
   fi
EOT

cp ../../scripts/labtainer-student/bin/labutils.py ./
docker build --build-arg DOCKER_GROUP_ID="$(getent group docker | cut -d: -f3)" -f base_dockerfiles/Dockerfile.labtainer.master -t labtainer.master:latest .
cd $here
