#!/bin/bash
# file: folder-files-structure.sh

## MEJORA DE PRÁCTICA DEVOPS: Usar rutas relativas para portabilidad.
# El script debe ejecutarse desde el directorio raíz del repositorio (donde está este archivo).

echo "Creando estructura de repositorio K8s..."

# 1. Creación de Directorios Principales
mkdir -p docs/01_FUNDAMENTOS
mkdir -p labs/lab_01_setup
mkdir -p SCRIPTS
mkdir -p .devcontainer # Agregamos .devcontainer para VS Code/Codespaces (Mejor Práctica)

# 2. Creación de Archivos Base
touch README.md
touch CONTRIBUTING.md
touch .gitignore
touch docs/01_FUNDAMENTOS/01_instalacion_minikube.md
touch SCRIPTS/01_minikube_setup.sh

echo "Estructura creada con éxito."
tree -a
