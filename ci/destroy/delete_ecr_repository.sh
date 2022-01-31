#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 
# Always run from the location of this script
cd $DIR

. ../common.sh

terraform destroy --auto-approve -var backend_project_name=$BACKEND_PROJECT_NAME
