# DEVOPS Project: Jenkins As Code with CI/CD pipeline from scratch
## Goal
Deploy a containerized API into a staging environment in a public cloud **automatically** whenever new commits are integrated into the main branch.

Stack:
* Cloud Platform: AWS
* Code Hosting Platform: GitHub
* CI/CD Tool: Jenkins with Jenkins Pipeline
* Infrastructure Management Tool: Terraform
* Configuration Management Tool: Ansible
* Image Management Tool: Packer 
* Container Build Tool: Docker
* API: Express.js
* Staging Environment for Jenkins: EC2 instance
* Staging Environment for API: ECS Fargate with ALB and application auto-scaling

Overview:
![Overview](https://github.com/thecloudprofessional/devops_cicd/blob/main/misc/devops_cicd-Overview.jpg)

## Part 1: Jenkins server on AWS EC2 instance
See the repository [devops_cicd](https://github.com/thecloudprofessional/devops_cicd).

## Part 2: Containerized API deployment with Jenkins Pipeline
Pipeline definition [here](/Jenkinsfile). 

![Pipeline](/misc/pipeline.png)

Stages:
* Checkout source code. Tool: GIT Jenkins plugin.
* Prebuild: create the ECR repository for the API. Tool: Terraform.
* Build: build the docker image for the API and push it to the ECR repository. Tools: Docker + AWS CLI.
* DeployStaging: build the staging environment for the API. Tool: Terraform.
* Destroy (on-demand): delete the staging environment and the ECR repository. Tool: Terraform.

#### Prerequisites
* S3 bucket to store the Terraform states (see "bucket" in the [prebuild configuration](/ci/prebuild/main.tf) and in the deploy [staging configuration](/ci/deploy/backend-staging.tf)).
* AWS CLI profile named **devops_jenkins** (see "profile" in the [prebuild configuration](/ci/prebuild/main.tf) and in the deploy [staging configuration](/ci/deploy/staging/main.tf)). Permissions needed: IAM, ELB, ECR, S3, CloudWatch Logs, ECS, and VPC.

#### Usage
Push some changes in the main branch of the current repo to trigger the pipeline in Jenkins.

Otherwise, you can also run a "logical copy" of the pipeline locally:
```
./ci/runPipelineLocally.sh
```
