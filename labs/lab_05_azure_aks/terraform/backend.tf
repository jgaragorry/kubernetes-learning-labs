# labs/lab_05_azure_aks/terraform/backend.tf
terraform {
  required_version = ">= 1.0.0"

  # Mejor Práctica: Solo declarar el tipo de backend.
  # La configuración completa se inyecta con -backend-config en el comando 'init'.
  backend "azurerm" {}
}
