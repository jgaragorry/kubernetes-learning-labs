# 🛠️ TROUBLESHOOTING_CHECKLIST.MD - Preparación SRE y Hacks de Velocidad

Este documento contiene acciones de validación y solución de problemas (Troubleshooting) de última hora que deben ejecutarse antes de iniciar el RUNBOOK.md para garantizar la máxima velocidad y evitar fallos de estado o permisos.

## I. VALIDACIÓN DEL ESTADO DE AZURE (Prevención de Fallas FinOps/SRE)

**Propósito:** Asegurar que los Resource Groups (RG) del laboratorio estén limpios para evitar errores de creación o cargos innecesarios.

| Acción | Comando de Chequeo | Observación Crítica |
| :--- | :--- | :--- |
| **Limpieza de AKS** | `az group show --name devops-lab-rg-aks` | **CRÍTICO:** El RG no debe existir (`NotFound`) o debe estar en estado `Deleting`. Si existe, debes destruirlo con `terraform destroy`. |
| **Chequeo de Backend** | `az group show --name rg-tfstate-backend-k8s` | **FINOPS:** Este RG debe existir y contener la Storage Account, pero si lo eliminaste, el script `07_create_tf_backend.sh` lo recreará. |

## II. OPTIMIZACIÓN DEL ENTORNO LOCAL (Aceleración DevOps)

**Propósito:** Garantizar que los tokens de sesión y las herramientas de Terraform sean válidas antes de iniciar la ejecución larga.

| Tarea de Estabilidad | Comando | Razón SRE |
| :--- | :--- | :--- |
| **Autenticación Azure** | `az login` y `az account show` | Asegura que el token de sesión de Azure esté activo y que el proveedor de Terraform tenga permisos. |
| **Reinicio de Bash** | (Cerrar y abrir sesión de WSL) | Garantiza que los permisos de Docker y los cambios de shell aplicados en el Nivel 1 estén activos y que la sesión esté limpia. |
| **Chequeo de Archivo Crítico** | `cat labs/lab_05_azure_aks/aks-web-app.yaml` | Confirma que el YAML de la aplicación (el Deployment y el Service LoadBalancer) tiene contenido y no está vacío, evitando el error `no objects passed to apply`. |

## III. HACKS DE ACELERACIÓN (Ahorro de Tiempo)

| Hack de Velocidad | Comandos (Acción Rápida) | Beneficio |
| :--- | :--- | :--- |
| **Pre-configuración del Backend** | `cd ~/kubernetes-learning-labs`<br>`./SCRIPTS/07_create_tf_backend.sh` | **Ahorro de Tiempo:** Crea el Storage Account y el archivo `backend.conf` mientras realizas otras tareas, eliminando los 1-2 minutos de espera del `terraform init`. |
| **Validación de la IP** | **`az aks show -g <RG> -n <CLUSTER> --query agentPoolProfiles[].vmSize`** | Puedes usar este comando después del `terraform apply` para verificar el estado de los nodos directamente en Azure en lugar de esperar el output de Terraform. |
