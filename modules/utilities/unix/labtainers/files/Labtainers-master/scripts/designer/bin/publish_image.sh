#!/bin/bash
: <<'END'
This software was created by United States Government employees at 
The Center for the Information Systems Studies and Research (CISR) 
at the Naval Postgraduate School NPS.  Please note that within the 
United States, copyright protection is not available for any works 
created  by United States Government employees, pursuant to Title 17 
United States Code Section 105.   This software is in the public 
domain and is not subject to copyright. 
END
usage(){
    echo "publish_image.sh image [-t]"
    echo "use -t to push to the testregistry:5000 registry for testing"
    exit
}

if [ $# -eq 0 ]; then
   usage
fi
if [[ $# -eq 1 ]]; then
    export LABTAINER_REGISTRY="mfthomps"
    if [ -z "$DOCKER_LOGIN" ]; then
        docker login
        DOCKER_LOGIN=YES
    fi
elif [[ "$2" == -t ]]; then
    export LABTAINER_REGISTRY="testregistry:5000"
else
   usage
fi
echo "Using registry $LABTAINER_REGISTRY"
image=$1
docker tag $image $LABTAINER_REGISTRY/$image
docker push $LABTAINER_REGISTRY/$image

