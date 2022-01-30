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

variable "backend_project_name" {
  type        = string
  description = "The name of the backend project"
}