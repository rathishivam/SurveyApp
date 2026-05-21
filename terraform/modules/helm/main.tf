# Generic Helm module
# Installs a Helm chart into Kubernetes.

resource "helm_release" "this" {
  name             = var.release_name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace

  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  values = var.values
}
