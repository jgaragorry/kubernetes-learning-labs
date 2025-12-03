#!/bin/bash
# file: SCRIPTS/04_lab_cleanup.sh
# PROPÓSITO: Elimina todos los recursos creados en el LAB 03 (PostgreSQL, PVC, ConfigMap, Secret).
# OBJETIVO SRE: Dejar el clúster en un estado limpio y conocido.

LAB_DIR="labs/lab_03_config_state"

echo "--- 🧹 Iniciando Limpieza de Recursos del LAB 03 (PostgreSQL) ---"

# 1. ELIMINAR OBJETOS DEFINIDOS EN YAML (Deployment y PVC)
echo "1. Eliminando Deployment y PVC..."
kubectl delete -f $LAB_DIR/db-config-storage.yaml 2>/dev/null
# Nota SRE: La PVC debe eliminarse junto con el Deployment.

# 2. ELIMINAR OBJETOS CREADOS POR LÍNEA DE COMANDOS (ConfigMap y Secret)
echo "2. Eliminando ConfigMap y Secret..."
kubectl delete configmap postgres-config 2>/dev/null
kubectl delete secret postgres-secret 2>/dev/null

# 3. VALIDACIÓN FINAL DE LIMPIEZA
echo -e "\n--- 3. Verificando Limpieza (No debería haber recursos) ---"

echo "Validando Pods/Deployments..."
kubectl get all -l app=postgres-db

echo "Validando PVCs..."
kubectl get pvc

echo -e "\n✅ ¡Limpieza del LAB 03 completada! Clúster listo para el Nivel 4."
