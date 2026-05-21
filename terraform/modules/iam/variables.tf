# IAM module variables

variable "project" {
  type        = string
  description = "Project name used in IAM role names"
}

variable "env" {
  type        = string
  description = "Environment label used in IAM role names"
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to IAM resources"
  default     = {}
}
