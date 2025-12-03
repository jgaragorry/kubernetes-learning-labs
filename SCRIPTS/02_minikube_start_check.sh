#!/bin/bash
# file: SCRIPTS/02_minikube_start_check.sh
# PROPÓSITO: Iniciar minikube y realizar chequeos de salud (Health Check).

echo "--- 🚦 Iniciando y validando clúster minikube... ---"

# --- 1. INICIO DEL CLÚSTER ---
# Si minikube ya está corriendo, este comando lo mantiene. Si no, lo crea (Idempotencia).
# Usamos el driver 'docker' y la configuración recomendada (4GB RAM, 2 CPU).
minikube start --driver=docker --memory=4096mb --cpus=2

# --- 2. VALIDACIONES Y CHEQUEO DE SALUD (SRE) ---
echo "--- 2.1. Realizando chequeos de salud del clúster (SRE)... ---"

# 2.1. Espera a que minikube esté listo
minikube status

# 2.2. Validación 1: Listar los nodos (debe haber 1 y estar Ready)
echo -e "\n--- Nodos del Clúster ---"
kubectl get nodes

# 2.3. Validación 2: Listar los Pods del sistema (Control Plane - deben estar Running)
echo -e "\n--- Pods del Control Plane (kube-system) ---"
kubectl get pods -n kube-system

echo -e "\n✨ ¡Clúster minikube listo para trabajar! ✨"
