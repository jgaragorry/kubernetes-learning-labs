#!/bin/bash
# file: SCRIPTS/07_create_tf_backend.sh (VERSIÓN MEJORADA CON INYECCIÓN)
# ... (Sección de creación idempotente del Resource Group y Storage Account permanece igual) ...

RG_BACKEND="rg-tfstate-backend-k8s"
SA_NAME="tfstate99aksb2s" 
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# ... (El código de creación de RG, SA, y Container, incluyendo la lógica idempotente, va aquí) ...

echo "--- 4. 📝 Inyectando Configuración del Backend en 'backend.conf' ---"

# Archivo de configuración que usará 'terraform init'
CONFIG_FILE="labs/lab_05_azure_aks/terraform/backend.conf"

# Contenido del archivo backend.conf (HCL/Terraform)
cat << EOF > $CONFIG_FILE
# labs/lab_05_azure_aks/terraform/backend.conf
# ESTE ARCHIVO FUE GENERADO AUTOMÁTICAMENTE POR EL SCRIPT
resource_group_name  = "$RG_BACKEND"
storage_account_name = "$SA_NAME"
container_name       = "$CONTAINER_NAME"
key                  = "aks-lab-05.tfstate"
EOF

echo "✅ Backend de Terraform Creado/Reutilizado con Éxito."
echo "Configuración escrita en $CONFIG_FILE. El Storage Account Name ($SA_NAME) ya está inyectado."
