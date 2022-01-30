#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Always run from the location of this script
cd $DIR

. ../common.sh

accountId=`aws sts get-caller-identity | grep "Account" | sed 's/"Account": "\(.*\)",/\1/' | awk '{gsub(/^[ \t]+/,""); print $0}'`
# todo debug message to delete
echo $accountId

docker build ../../backend -t $BACKEND_PROJECT_NAME

aws ecr get-login-password | docker login --username AWS --password-stdin $accountId.dkr.ecr.ca-central-1.amazonaws.com

docker tag $BACKEND_PROJECT_NAME:latest $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest

docker push $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest