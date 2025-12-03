#!/bin/bash
# file: SCRIPTS/02_lab_deploy.sh
# PROPÓSITO: Despliega la aplicación del LAB 02 y realiza validaciones iniciales.
# MEJOR PRÁCTICA DEVOPS: Usar 'apply' para aplicar IaC (Infrastructure as Code).

DEPLOY_FILE="labs/lab_02_deploy_app/web-deployment-service.yaml"
APP_LABEL="app=web-hello"

echo "--- 1. Aplicando el Despliegue (Deployment y Service) ---"
kubectl apply -f $DEPLOY_FILE

# --- 2. VALIDACIONES INICIALES ---
echo -e "\n--- 2.1. Chequeo de Salud de Objetos Principales (Deployment y Service) ---"
# Verificamos que el Deployment esté en estado Ready (3/3) y el Service tenga NodePort asignado.
kubectl get deployments,services -l $APP_LABEL

# --- 3. VALIDACIÓN DE PODS (Unidad de Ejecución) ---
echo -e "\n--- 2.2. Pods ANTES de la simulación de falla (Debe mostrar 3 Pods en estado Running) ---"
kubectl get pods -l $APP_LABEL

echo -e "\n--- ✅ Despliegue completado. Ahora proceda a la TAREA 2.3 para probar la resiliencia (auto-curación). ---"
