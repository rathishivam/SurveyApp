# Variables for EKS addons module

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster where addons will be installed"
}

variable "addon_names" {
  type        = list(string)
  description = "List of EKS addon names to install"
  default     = ["vpc-cni", "coredns", "kube-proxy"]
}
