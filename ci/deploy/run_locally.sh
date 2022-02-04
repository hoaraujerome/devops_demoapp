#!/usr/bin/env bash

BACKEND_PROJECT_NAME="node-devops_demoapp_backend"
TF_ENV=$1
 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 
# Always run from the location of this script
cd $DIR

accountId=`aws sts get-caller-identity | grep "Account" | sed 's/"Account": "\(.*\)",/\1/' | awk '{gsub(/^[ \t]+/,""); print $0}'`

if [ $# -gt 0 ]; then
    if [ "$2" == "init" ]; then
      terraform -chdir=./$TF_ENV init -backend-config=../backend-$TF_ENV.tf
    elif [ "$2" == "deploy" ]; then
      terraform fmt --recursive
      terraform -chdir=./$TF_ENV validate
      terraform -chdir=./$TF_ENV apply -var aws_ecr_backend_repository_url="${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}"
    else
      terraform -chdir=./$TF_ENV $2 -var aws_ecr_backend_repository_url="${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}"
    fi
fi
 
# Head back to original location to avoid surprises
cd -