# 📘 ASSET_GUIDE.MD - Diccionario de Archivos y Funciones

Este documento complementa el `README.md` y `RUNBOOK.md` al detallar el **propósito, contenido y lógica** de cada archivo, script y directorio en el repositorio.

---

## I. 📂 Guía de Directorios y Organización por Rol

| Directorio | Archivos Almacenados | Función de Rol |
| :--- | :--- | :--- |
| **`SCRIPTS/`** | Bash (`.sh`) | **DevOps/SRE:** Lógica de automatización, orquestación de tareas y aseguramiento de la repetibilidad. |
| **`labs/`** | YAML, `.tf` | **Ingeniero:** Código declarativo (IaC) que define el estado real de la infraestructura y aplicaciones K8s. |
| **`labs/lab_05_azure_aks/terraform/`** | `.tf`, `.conf` | **IaC Avanzada:** Componentes modulares para Terraform, enfocados en seguridad, FinOps y despliegue en la nube. |

---

## II. ⚙️ Archivos de Automatización (SCRIPTS/)

| Archivo | Cuándo se Usa | Contenido Clave (¿Qué hace?) | Por qué existe (BP) |
| :--- | :--- | :--- | :--- |
| **`01_minikube_setup.sh`** | Nivel 1 Setup | Instala Docker, `kubectl` y `minikube`. | **BP SRE:** Asegura que los prerrequisitos se instalen de forma centralizada y verifica el estado inicial del clúster. |
| **`02_lab_deploy.sh`** | Nivel 2 | Despliega los objetos K8s del LAB 02. | **BP DevOps:** Automatiza `kubectl apply -f <YAML>` para el despliegue de la aplicación. |
| **`07_create_tf_backend.sh`** | Nivel 5 Setup | Crea el **Backend de Terraform** en Azure Storage. | **BP DevSecOps/FinOps:** Implementación **Idempotente**, fuerza **TLS 1.2** y aplica **etiquetas de costo** a la Storage Account. |
| **`deploy-aks.sh`** | Nivel 5 Despliegue | Ejecuta el ciclo completo de Terraform, configura `kubectl` y despliega la aplicación de la nube. | **BP IaC:** Encapsula `terraform init/apply` y `az aks get-credentials` para la transición fluida a la nube. |
| **`08_cleanup_tf_backend.sh`**| Nivel 5 Cleanup | Elimina el Resource Group del Backend. | **BP FinOps:** Asegura la destrucción del Storage Account para evitar cargos residuales después de finalizar el laboratorio. |

---

## III. 💻 Archivos de Configuración K8s y Terraform (labs/)

### A. Archivos de Aplicación (YAMLs)

| Archivo | LAB | Contenido Principal | Propósito y Lo que Aprendes |
| :--- | :--- | :--- | :--- |
| **`web-deployment-service.yaml`** | 2 | `Deployment`, `Service (NodePort)` | Implementas **Resiliencia (SRE)** y la exposición por puerto local (`NodePort`) en Minikube. |
| **`db-config-storage.yaml`** | 3 | `Deployment`, `PVC`, inyección de `Secrets` y `ConfigMaps`. | Demuestras el desacoplamiento de configuración (DevSecOps) y la **Persistencia de Datos (SRE)**. |
| **`aks-web-app.yaml`** | 5 | `Deployment`, `Service (LoadBalancer)` | **Adaptación a la Nube:** Cambias la exposición a **`type: LoadBalancer`** para obtener una IP pública de Azure. |

### B. Archivos de Terraform (labs/lab_05_azure_aks/terraform/)

| Archivo | Bloque Principal | Propósito y Función Crítica |
| :--- | :--- | :--- |
| **`backend.tf`** | `backend "azurerm" {}` | **Control de Estado:** Declara a Terraform que use Azure Storage para guardar el archivo `tfstate` de forma remota y segura. |
| **`backend.conf`** | `resource_group_name = "..."` | **Inyección de Config:** Contiene los parámetros de conexión al Storage Account. Se inyecta al `terraform init` para la automatización. |
| **`providers.tf`** | `provider "azurerm"` | Configura la conexión al proveedor de la nube de Azure y al proveedor de Kubernetes. |
| **`variables.tf`** | `variable "aks_vm_size"` | Centraliza los parámetros de configuración, especialmente la VM `Standard_B2s` (BP **FinOps**). |
| **`network.tf`** | `resource "azurerm_virtual_network"` | **Redes SRE:** Define la VNet, Subnet y el Resource Group del clúster. |
| **`aks.tf`** | `resource "azurerm_kubernetes_cluster"` | **Configuración Central:** Define el clúster. Contiene la corrección crítica de **`service_cidr = "172.16.0.0/20"`** para evitar conflictos de red. |
| **`outputs.tf`** | `output "kube_config"` | **Interoperabilidad:** Exporta datos necesarios (nombre del clúster, `kube_config_raw` sensible) para que el script Bash (`deploy-aks.sh`) pueda configurar `kubectl`. |
