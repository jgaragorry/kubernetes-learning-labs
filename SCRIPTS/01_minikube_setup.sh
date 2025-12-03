#!/bin/bash
# file: SCRIPTS/01_minikube_setup.sh
# PROPÓSITO: Instalar todos los prerrequisitos (Docker, kubectl) y minikube.
# OBJETIVO SRE: Asegurar la repetibilidad (idempotencia) del ambiente.

echo "--- 🛠️ Iniciando Instalación de Prerrequisitos (Docker, kubectl, minikube) ---"

# --- 1. INSTALACIÓN DE DOCKER ---
echo "--- 1.1. Instalando y configurando Docker Engine... ---"

# 1.1. Actualizar e instalar dependencias
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# 1.2. Agregar Clave GPG y Repositorio de Docker
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# 1.3. Instalar Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 1.4. Agregar usuario al grupo docker (Permisos)
if ! grep -q "docker" /etc/group | grep -q "$USER"; then
    echo "Agregando usuario $USER al grupo docker. Requiere re-login para aplicar."
    sudo usermod -aG docker $USER
fi

# 1.5. Iniciar servicio Docker
sudo systemctl start docker
sudo systemctl enable docker

# --- 2. INSTALACIÓN DE KUBECTL ---
echo "--- 2.1. Instalando kubectl (CLI de Kubernetes)... ---"

# 2.1. Descargar e instalar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl # Limpieza (Mejor Práctica)

# --- 3. INSTALACIÓN DE MINIKUBE ---
echo "--- 3.1. Instalando minikube... ---"

# 3.1. Descargar e instalar minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64 # Limpieza

echo "--- ✅ Instalación de Herramientas Completada. Re-loguea tu WSL para usar Docker sin sudo. ---"
