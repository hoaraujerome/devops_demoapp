# DEVOPS Project
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

## Part 2: Deploy the API with Jenkins Pipeline
Pipeline definition [here](/Jenkinsfile). 

![Pipeline](/misc/pipeline.png)

Stages:
* Checkout source code. Tool: GIT Jenkins plugin.
* Prebuild: create the ECR repository for the API. Tool: Terraform.
* Build: build the docker image for the API and push it to the ECR repository. Tools: Docker + AWS CLI.
* DeployStaging: build the staging environment. Tool: Terraform.
* Destroy (on-demand): delete the staging environment and the ECR repository. Tool: Terraform.
