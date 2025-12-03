#!/bin/bash
# file: SCRIPTS/06_setup_lab_structure.sh
# PROPÓSITO: Crea la estructura de directorios y archivos para el LAB 05 (Transición a la Nube/FinOps).

echo "--- 🏗️ Creando estructura de LAB 05 (Azure AKS y FinOps) ---"

# 1. Creación de Directorios
mkdir -p docs/05_TRANSICION_NUBE_FINOPS
mkdir -p labs/lab_05_azure_aks

# 2. Creación de Archivos Base
touch docs/05_TRANSICION_NUBE_FINOPS/01_aks_deploy_finops.md
touch labs/lab_05_azure_aks/aks-web-app.yaml

echo "✅ Estructura del LAB 05 creada con éxito."
