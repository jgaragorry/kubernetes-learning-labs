#!/bin/bash
# file: SCRIPTS/07_setup_tf_structure.sh
# PROPÓSITO: Crea la estructura modular de Terraform para el despliegue de AKS (LAB 05).

LAB_DIR="labs/lab_05_azure_aks"

echo "--- 🏗️ Creando estructura modular de Terraform para AKS ---"

# 1. Creación de Directorio Raíz de Terraform
mkdir -p $LAB_DIR/terraform

# 2. Creación de Archivos de Configuración de Terraform
touch $LAB_DIR/terraform/backend.tf
touch $LAB_DIR/terraform/providers.tf
touch $LAB_DIR/terraform/aks.tf
touch $LAB_DIR/terraform/network.tf
touch $LAB_DIR/terraform/variables.tf
touch $LAB_DIR/terraform/outputs.tf

# 3. Creación del Script de Despliegue de K8s post-Terraform
touch $LAB_DIR/deploy-aks.sh
chmod 750 $LAB_DIR/deploy-aks.sh # Dar permisos de ejecución

echo "✅ Estructura de Terraform para el LAB 05 creada con éxito."
