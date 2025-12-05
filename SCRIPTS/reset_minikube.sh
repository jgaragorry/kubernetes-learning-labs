#!/bin/bash
# file: SCRIPTS/reset_minikube.sh (Versión Robustecida SRE)
# Propósito: Limpiar completamente el entorno K8s local para un State Zero.

echo -e "\t--- 🧹 Iniciando Reset Completo de Minikube (SRE) ---"

# 1. Detener y Eliminar el Clúster
echo -e "\t Deteniendo y eliminando Minikube (ignorando errores si ya está detenido)..."
minikube stop 2>/dev/null
minikube delete 2>/dev/null
echo -e "\t ✅ Clúster K8s eliminado."

# 2. Eliminar Archivos de Configuración Local
echo -e "\t Eliminando archivos de configuración de estado local: $HOME/.kube y $HOME/.minikube"
rm -rf $HOME/.kube $HOME/.minikube
echo -e "\t ✅ Archivos de estado limpiados."

echo -e "\t--- ✨ Entorno K8s local listo para la nueva ejecución ---"
