# S3 module variables

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for UI hosting"
}

variable "force_destroy" {
  type        = bool
  description = "Destroy the bucket and all objects when the bucket is removed"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to the S3 bucket"
  default     = {}
}
