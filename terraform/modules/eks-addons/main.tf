# EKS addons module
# Installs managed EKS addons on the cluster.

resource "aws_eks_addon" "this" {
  for_each = toset(var.addon_names)

  cluster_name = var.cluster_name
  addon_name   = each.value

  # If the cluster version changes, the addon will update automatically.
#   resolve_conflicts = "OVERWRITE"
}
