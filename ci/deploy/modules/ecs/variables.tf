variable "iac_tool" {
  type        = string
  description = "Name of the IAC tool used to provision the infra"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment"
}

variable "aws_ecr_backend_repository_url" {
  type        = string
  description = "The URL of the backend ECR repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName"
}

variable "region" {
  type        = string
  description = "The region where the infrastructure is provisioned"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs"
}
