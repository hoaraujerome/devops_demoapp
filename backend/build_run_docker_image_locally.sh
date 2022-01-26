#!/usr/bin/env bash

TF_ENV=$1
 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DOCKER_IMAGE_NAME="node-devops_demoapp_backend"

# Always run from the location of this script
cd $DIR

docker build . -t $DOCKER_IMAGE_NAME

docker run -p 80:8080 -d $DOCKER_IMAGE_NAME
