variable "iac_tool" {
  type        = string
  description = "Name of the IAC tool used to provision the infra"
  default     = "terraform"
}
variable "project" {
  type        = string
  description = "The name of the project"
  default     = "devops_demoapp"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment"
  default     = "staging"
}

variable "region" {
  type        = string
  description = "The region where the infrastructure is provisioned"
  default     = "ca-central-1"
}

variable "public_subnet_numbers" {
  type = map(number)

  description = "Map of AZ to a number that should be used for public subnets"

  default = {
    "ca-central-1a" = 1
    "ca-central-1b" = 2
  }
}

variable "private_subnet_numbers" {
  type = map(number)

  description = "Map of AZ to a number that should be used for private subnets"

  default = {
    "ca-central-1a" = 3
    "ca-central-1b" = 4
  }
}

variable "aws_ecr_backend_repository_url" {
  type        = string
  description = "The URL of the backend ECR repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName"
}