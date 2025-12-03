# labs/lab_05_azure_aks/terraform/aks.tf (ARCHIVO COMPLETO Y CORREGIDO)
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  # --- ARGUMENTOS REQUERIDOS ---
  name                = "${var.cluster_prefix}-aks"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "${var.cluster_prefix}-dns"

  # --- CONFIGURACIÓN FINOPS/DEVSECOPS ---
  identity {
    type = "SystemAssigned"
  }
  tags = azurerm_resource_group.rg_aks.tags # Aplica las etiquetas FinOps

  # --- BLOQUE REQUERIDO: NODO POOL ---
  default_node_pool {
    name                 = "systempool"
    vm_size              = var.aks_vm_size # FinOps: Standard_B2s
    node_count           = var.aks_node_count
    vnet_subnet_id       = azurerm_subnet.subnet_aks.id
    os_disk_size_gb      = 30
  }

  # --- BLOQUE CRÍTICO CORREGIDO: NETWORK PROFILE (SRE: EVITAR CONFLICTO) ---
  network_profile {
    # Argumento Requerido
    network_plugin = "kubenet" 
    
    # CORRECCIÓN DE RED SRE: Usar un CIDR distinto a la VNet (10.0.0.0/16)
    service_cidr     = "172.16.0.0/20"
    dns_service_ip   = "172.16.0.10"
  }
}
