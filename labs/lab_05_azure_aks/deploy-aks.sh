#!/bin/bash
# file: labs/lab_05_azure_aks/deploy-aks.sh
# PROPÓSITO: Automatiza el despliegue de K8s POST-Terraform.
# **IMPORTANTE: ESTE SCRIPT DEBE EJECUTARSE DESDE EL DIRECTORIO labs/lab_05_azure_aks/**

TF_DIR="./terraform"

echo "--- 1. Asumiendo que Terraform ha aplicado la infraestructura ---"
# **NOTA:** La inicialización y aplicación se harán manualmente para garantizar rutas.

# --- 2. CONFIGURACIÓN FINAL DE KUBECTL ---
echo -e "\n--- 2.1. Configurando kubectl para el nuevo clúster AKS ---"

# Obtener los nombres de los recursos del output de Terraform
# Nota: Ahora usamos -chdir para asegurar que lea los outputs correctos.
RESOURCE_GROUP_NAME=$(terraform -chdir=$TF_DIR output -raw aks_rg_name)
CLUSTER_NAME=$(terraform -chdir=$TF_DIR output -raw aks_cluster_name)

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --overwrite-existing

echo -e "\n--- 2.2. Validación Inicial del Clúster (SRE Health Check) ---"
kubectl get nodes

# --- 3. DESPLIEGUE DE LA APLICACIÓN K8S ---
echo -e "\n--- 3. Despliegue de Aplicación Web (Adaptación LoadBalancer) ---"

# Aplicar el YAML adaptado para la nube (la ruta es CORRECTA ahora)
kubectl apply -f aks-web-app.yaml

echo -e "\n⏳ Esperando a que el LoadBalancer obtenga una IP pública (~1-2 minutos)..."
kubectl get service web-hello-service-aks --watch
