# EKS module variables

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the cluster"
  default     = "1.28"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster control plane"
}
variable "eks_admin_arn" {
  type = string
}
variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for EKS worker nodes"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used by the EKS control plane"
}

variable "node_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used by the EKS node group"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for the EKS node group"
  default     = "t3.medium"
}

variable "node_desired_size" {
  type        = number
  description = "Desired size for the EKS managed node group"
  default     = 2
}

variable "node_min_size" {
  type        = number
  description = "Minimum node count for the EKS managed node group"
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum node count for the EKS managed node group"
  default     = 3
}

variable "tags" {
  type        = map(string)
  description = "Tags to attach to the EKS cluster and node group"
  default     = {}
}
