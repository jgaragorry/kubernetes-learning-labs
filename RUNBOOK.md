# 📜 RUNBOOK.MD - Guía de Ejecución y Dominio de Kubernetes

Este documento sirve como el **Runbook Operacional** para la ejecución metódica de los laboratorios. Debe ejecutarse **secuencialmente** para garantizar que cada fase de aprendizaje y configuración se complete correctamente, asegurando la **repetibilidad** del workshop.

### ⚠️ Pre-requisitos Críticos
1.  **Ambiente:** WSL 2 (Ubuntu Server 24.04 LTS).
2.  **Herramientas Locales:** Docker, `kubectl`, `minikube`, **Azure CLI** y **Terraform** (necesarios antes del Nivel 5).
3.  **Acceso a la Nube:** Una cuenta activa de Azure para el Nivel 5 (sujeto a costos FinOps).

---

## FASE I: Setup Local y Fundamentos (Niveles 1 y 2)

**Objetivo:** Crear un clúster local (`minikube`) y dominar los objetos básicos y la resiliencia K8s.

| Paso | Acción de Ejecución | Directorios/Scripts Usados | Logro (Objetivo Cumplido) |
| :--- | :--- | :--- | :--- |
| **I.1. Setup Local** | Ejecutar la instalación de prerrequisitos. | `SCRIPTS/01_minikube_setup.sh` | **SRE/DevOps:** Instalación de Docker y `kubectl`. **BP:** Idempotencia y seguridad. |
| **I.2. Inicio de K8s** | Iniciar y validar el clúster minikube. | `SCRIPTS/02_minikube_start_check.sh` | **SRE:** Clúster `minikube` en estado `Ready`. Entendimiento de la arquitectura Control Plane. |
| **I.3. Despliegue Core** | Desplegar la aplicación de prueba. | `labs/lab_02_deploy_app/web-deployment-service.yaml` | Creación del Deployment (`replicas: 3`) y Service (`NodePort`). |
| **I.4. Validación SRE** | Forzar la eliminación de un Pod. | (Manual: `kubectl delete pod <nombre>`) | **SRE:** Validación de la **Auto-curación**. El Controller Manager reemplaza el Pod eliminado. |

---

## FASE II: Configuración, Persistencia y Observabilidad (Niveles 3 y 4)

**Objetivo:** Aplicar mejores prácticas de DevSecOps para la gestión de datos y configuración, y configurar el networking avanzado.

| Paso | Acción de Ejecución | Directorios/Scripts Usados | Logro (Objetivo Cumplido) |
| :--- | :--- | :--- | :--- |
| **II.1. Creación de Config** | Crear ConfigMap y Secret. | (Manual: `kubectl create configmap/secret`) | **DevSecOps:** Credenciales (`Secret`) y configuración (`ConfigMap`) desacopladas. |
| **II.2. Persistencia** | Desplegar PostgreSQL que usa los Secrets/ConfigMaps y pide Storage. | `labs/lab_03_config_state/db-config-storage.yaml` | **SRE:** PVC en estado `Bound`. Los datos de la DB sobreviven a la vida del Pod. |
| **II.3. Networking Avanzado** | Habilitar Ingress y desplegar la regla L7. | `minikube addons enable ingress`, `labs/lab_04_ingress_monitor/ingress-web-app.yaml` | **Networking:** El Ingress Controller está activo. La aplicación es accesible por nombre (`hello.devops.lab`). |
| **II.4. Observabilidad** | Activar la interfaz gráfica. | `minikube dashboard &` | **SRE:** El Dashboard está operativo, proporcionando visibilidad del estado de Pods y Nodos. |
| **II.5. Cleanup** | Eliminar los recursos del LAB 03. | `SCRIPTS/04_lab_cleanup.sh` | **SRE:** Clúster limpio y listo para la transición a la nube. |

---

## FASE III: Transición a la Nube (Nivel 5 - AKS con Terraform)

**Objetivo:** Desplegar infraestructura de grado productivo con IaC, aplicando FinOps, DevSecOps y resolviendo conflictos de red críticos.

| Paso | Acción de Ejecución | Directorios/Scripts Usados | Logro (Objetivo Cumplido) |
| :--- | :--- | :--- | :--- |
| **III.1. Setup IaC** | Crear el Storage Account para el estado de Terraform y autenticar `az login`. | `SCRIPTS/07_create_tf_backend.sh` | **DevSecOps/FinOps:** Backend de estado creado (TLS 1.2, Etiquetas, Idempotente). |
| **III.2. Inicialización TF** | Navegar e inicializar Terraform. | `cd labs/lab_05_azure_aks/terraform`<br>`terraform init -backend-config=backend.conf` | **IaC:** Conexión exitosa al backend cifrado para guardar el `tfstate`. |
| **III.3. Despliegue de Infra** | Crear AKS (el proceso largo). | `terraform apply -auto-approve tfplan` | **SRE/FinOps:** Clúster AKS creado con corrección crítica de **Service CIDR** y VM `Standard_B2s`. |
| **III.4. Despliegue de App** | Configurar `kubectl` y desplegar la aplicación. | `cd ..`<br>`./deploy-aks.sh` | **DevOps:** `kubectl` apunta a Azure. La aplicación se despliega con **`type: LoadBalancer`**. |
| **III.5. Validación Final** | Obtener la IP pública. | (Comando final de `deploy-aks.sh`) | **SRE:** Service obtiene una **IP Pública** (`EXTERNAL-IP`), confirmando la conectividad en la nube. |

---

## 🧹 FASE IV: Limpieza Final y Retirada de Costos (FinOps)

**Objetivo:** Destruir todos los recursos de Azure para detener la facturación y mantener la cuenta limpia.

| Paso | Acción de Ejecución | Directorios/Scripts Usados | Propósito FinOps/SRE |
| :--- | :--- | :--- | :--- |
| **IV.1. Destruir AKS** | Eliminar el clúster AKS, VNet, Subnet y Load Balancer. | `cd labs/lab_05_azure_aks`<br>`terraform -chdir=terraform destroy -auto-approve` | **FinOps:** Detener los cargos por VMs y Control Plane (el costo principal). |
| **IV.2. Destruir Backend** | Eliminar el Resource Group del Storage Account de estado. | `cd ../../`<br>`./SCRIPTS/08_cleanup_tf_backend.sh` | **FinOps:** Eliminar el riesgo de cargos por almacenamiento de estado. |
