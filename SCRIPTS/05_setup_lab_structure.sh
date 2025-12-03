#!/bin/bash
# file: SCRIPTS/05_setup_lab_structure.sh
# PROPÓSITO: Crea la estructura de directorios y archivos para el LAB 04 (Networking y Observabilidad).

echo "--- 🏗️ Creando estructura de LAB 04 (Networking y Observabilidad) ---"

# 1. Creación de Directorios
mkdir -p docs/04_NETWORKING_OBSERVABILIDAD
mkdir -p labs/lab_04_ingress_monitor

# 2. Creación de Archivos Base
touch docs/04_NETWORKING_OBSERVABILIDAD/01_ingress_dashboard.md
touch labs/lab_04_ingress_monitor/ingress-web-app.yaml

echo "✅ Estructura del LAB 04 creada con éxito."
