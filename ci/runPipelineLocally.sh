#!/usr/bin/env bash

BACKEND_PROJECT_NAME="node-devops_demoapp_backend"

## Create ECR repository
terraform -chdir=./prebuild init
terraform -chdir=./prebuild apply -var backend_project_name=$BACKEND_PROJECT_NAME

## Build push Docker image
accountId=`aws sts get-caller-identity | grep "Account" | sed 's/"Account": "\(.*\)",/\1/' | awk '{gsub(/^[ \t]+/,""); print $0}'`

docker buildx build --platform=linux/amd64 ../backend -t $BACKEND_PROJECT_NAME

aws ecr get-login-password | docker login --username AWS --password-stdin $accountId.dkr.ecr.ca-central-1.amazonaws.com

docker tag $BACKEND_PROJECT_NAME:latest $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest

docker push $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest

# Delete ECR repository
terraform -chdir=./prebuild destroy -var backend_project_name=$BACKEND_PROJECT_NAME