# labs/lab_05_azure_aks/terraform/outputs.tf
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_rg_name" {
  value = azurerm_resource_group.rg_aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true # DevSecOps: Marca la configuración como sensible
}
