#!/bin/bash
# file: SCRIPTS/07_create_tf_backend.sh (VERSIÓN FINAL Y FUNCIONAL)
# PROPÓSITO: Crea los recursos de Azure para el backend de Terraform de forma IDEMPOTENTE y SEGURA.

RG_BACKEND="rg-tfstate-backend-k8s"
SA_NAME="tfstate99aksb2s" # **DEBE SER ÚNICO A NIVEL GLOBAL**
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# --- 1. GRUPO DE RECURSOS (IDEMPOTENTE) ---
echo "--- 🔒 1. Creación Idempotente del Grupo de Recursos ($RG_BACKEND) ---"

if az group show --name $RG_BACKEND &>/dev/null; then
    echo "Grupo de recursos $RG_BACKEND ya existe. Reutilizando."
else
    echo "Grupo de recursos $RG_BACKEND no existe. Creando..."
    az group create --name $RG_BACKEND --location $LOCATION --output none
    echo "✅ Grupo de recursos creado."
fi

# --- 2. STORAGE ACCOUNT (IDEMPOTENTE + DEVSECOPS/FINOPS) ---
echo "--- 💾 2. Creación/Actualización Idempotente del Storage Account ($SA_NAME) ---"

# Creación o actualización idempotente de la Storage Account con TLS 1.2 y etiquetas FinOps.
az storage account create \
    --resource-group $RG_BACKEND \
    --name $SA_NAME \
    --sku Standard_LRS \
    --encryption-services blob \
    --min-tls-version TLS1_2 \
    --tags Environment=Lab Project=K8s_Dominio CostCenter=DevOps \
    --output none 2>/dev/null 

echo "✅ Storage Account creada o actualizada con TLS 1.2 y etiquetas FinOps."

# --- 3. CONTENEDOR (IDEMPOTENTE) ---
echo "--- 📦 3. Creación/Actualización del Contenedor ($CONTAINER_NAME) ---"

# Crea el contenedor de estado.
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $SA_NAME \
    --fail-on-exist false \
    --output none 2>/dev/null

echo "✅ Contenedor de estado creado o reutilizado."

# --- 4. INYECCIÓN DE CONFIGURACIÓN AUTOMÁTICA ---
echo "--- 4. 📝 Inyectando Configuración del Backend en 'backend.conf' ---"

CONFIG_FILE="labs/lab_05_azure_aks/terraform/backend.conf"
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
