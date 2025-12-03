# labs/lab_05_azure_aks/terraform/variables.tf
variable "location" {
  description = "La región de Azure donde se desplegarán los recursos."
  default     = "EastUS"
}

variable "cluster_prefix" {
  description = "Prefijo para los nombres de recursos."
  default     = "devops-lab"
}

# FinOps: Parámetros del pool de nodos
variable "aks_node_count" {
  description = "Número inicial de nodos en el cluster (FinOps: Mantener en 1 para reducir costos)."
  default     = 1
}

variable "aks_vm_size" {
  description = "Tamaño de la VM de los nodos (FinOps: Standard_B2s es bajo costo)."
  default     = "Standard_B2s" 
}
