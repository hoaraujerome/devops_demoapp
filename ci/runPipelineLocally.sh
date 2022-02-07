#!/usr/bin/env bash

BACKEND_PROJECT_NAME="node-devops_demoapp_backend"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 
# Always run from the location of this script
cd $DIR

accountId=`aws sts get-caller-identity | grep "Account" | sed 's/"Account": "\(.*\)",/\1/' | awk '{gsub(/^[ \t]+/,""); print $0}'`

## PREBUILD STAGE
# Create ECR repository
terraform -chdir=./prebuild init
terraform -chdir=./prebuild apply --auto-approve -var backend_project_name=$BACKEND_PROJECT_NAME

## BUILD STAGE
# Build Docker image
docker buildx build --platform=linux/amd64 ../backend -t $BACKEND_PROJECT_NAME

# Push Docker image
aws ecr get-login-password | docker login --username AWS --password-stdin $accountId.dkr.ecr.ca-central-1.amazonaws.com
docker tag $BACKEND_PROJECT_NAME:latest $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest
docker push $accountId.dkr.ecr.ca-central-1.amazonaws.com/$BACKEND_PROJECT_NAME:latest

## DEPLOY STAGING STAGE
terraform -chdir=./deploy/staging init -backend-config=../backend-staging.tf
terraform -chdir=./deploy/staging apply --auto-approve -var aws_ecr_backend_repository_url="${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}"

## DESTROY STAGE
# Delete the staging environment
terraform -chdir=./deploy/staging destroy -var aws_ecr_backend_repository_url="${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}"
# Delete ECR repository
terraform -chdir=./prebuild destroy -var backend_project_name=$BACKEND_PROJECT_NAME

# Head back to original location to avoid surprises
cd -