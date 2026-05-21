# Outputs for EKS addons module

output "addons_installed" {
  description = "Names of EKS addons installed"
  value       = [for addon in aws_eks_addon.this : addon.addon_name]
}
