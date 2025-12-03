# labs/lab_05_azure_aks/terraform/network.tf
resource "azurerm_resource_group" "rg_aks" {
  name     = "${var.cluster_prefix}-rg-aks"
  location = var.location
  tags = {
    Environment = "Lab"
    Project     = "K8s_Dominio"
    CostCenter  = "DevOps" # FinOps Tagging
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.cluster_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
}

resource "azurerm_subnet" "subnet_aks" {
  name                 = "${var.cluster_prefix}-subnet-aks"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
