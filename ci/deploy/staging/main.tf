terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  backend "s3" {
    region = "ca-central-1"
  }
}

provider "aws" {
  profile = "devops_jenkins"
  region  = "ca-central-1"
}

module "vpc" {
  source = "../modules/vpc"

  iac_tool               = var.iac_tool
  project                = var.project
  environment            = var.environment
  public_subnet_numbers  = var.public_subnet_numbers
  private_subnet_numbers = var.private_subnet_numbers
}

module "ecs" {
  source = "../modules/ecs"

  iac_tool                       = var.iac_tool
  project                        = var.project
  environment                    = var.environment
  aws_ecr_backend_repository_url = var.aws_ecr_backend_repository_url
  region                         = var.region
  vpc_id                         = module.vpc.vpc_id
  public_subnet_ids              = module.vpc.vpc_public_subnet_ids
  private_subnet_ids             = module.vpc.vpc_private_subnet_ids
}
