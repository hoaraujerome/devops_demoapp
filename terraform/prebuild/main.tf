terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73"
    }
  }

  backend "s3" {
    region = "ca-central-1"
    bucket = "thecloudprofessional-devops-demoapp"
    key    = "iac/prebuild/terraform.tfstate"
  }
}

provider "aws" {
  profile = "devops_demoapp"
  region  = "ca-central-1"
}

## Create ECR repository
resource "aws_ecr_repository" "repository" {
  name = var.project

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name      = "${var.project}"
    ManagedBy = "${var.iac_tool}"
  }
}