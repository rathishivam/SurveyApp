# CloudFront module variables

variable "name" {
  type        = string
  description = "Name used to label CloudFront resources"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name used by the CloudFront distribution"
}

variable "bucket_domain_name" {
  type        = string
  description = "S3 bucket domain name used as CloudFront origin"
}

variable "default_root_object" {
  type        = string
  description = "Default root object served by CloudFront"
  default     = "index.html"
}

variable "tags" {
  type        = map(string)
  description = "Tags for CloudFront resources"
  default     = {}
}
