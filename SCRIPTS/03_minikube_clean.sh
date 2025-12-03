#!/bin/bash
# file: SCRIPTS/03_minikube_clean.sh
# PROPÓSITO: Limpiar completamente el entorno de Kubernetes y Docker.
# OBJETIVO SRE: Dejar el ambiente en un estado inicial conocido (State Zero).

echo "--- 🧹 Iniciando Proceso de Limpieza Total del Entorno ---"

# --- 1. LIMPIEZA DE MINIKUBE ---
echo "--- 1.1. Deteniendo y eliminando el clúster minikube... ---"
minikube stop 2>/dev/null
minikube delete 2>/dev/null

# 1.2. Eliminando el directorio de configuración de minikube
rm -rf ~/.minikube

# --- 2. LIMPIEZA DE CONFIGURACIÓN K8S ---
echo "--- 2.1. Eliminando configuración local de kubectl... ---"
# El archivo kubeconfig almacena las credenciales y el endpoint del clúster.
rm -rf ~/.kube

# --- 3. LIMPIEZA DE DOCKER (Contenedores y Redes) ---
echo "--- 3.1. Eliminando Contenedores, Imágenes, Volúmenes y Redes (DevOps/SRE)... ---"
# Eliminar todos los contenedores no utilizados
docker container prune -f 2>/dev/null
# Eliminar todas las imágenes, volúmenes y redes creadas por Docker que no estén en uso.
# Es una limpieza profunda para asegurar espacio y estado limpio.
docker system prune --all --volumes -f 2>/dev/null

echo "--- 🗑️ Limpieza Completa. El entorno de K8s ha sido restablecido a su estado inicial. ---"
