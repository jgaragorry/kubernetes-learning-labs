# 🚀 EXECUTION_GUIDE.MD - Guía de Ejecución Rápida y Repetible

Este documento es la **Guía Maestra de Ejecución** del Workshop de Kubernetes. Sigue los pasos *exactos* y en el *orden especificado* para reproducir el workshop N veces con éxito.

## 📌 Principios de Ejecución (SRE)

1.  **Estado Cero:** Siempre inicia limpiando el entorno (FASE 0).
2.  **Ruta de Trabajo:** Todos los comandos se ejecutan desde el directorio raíz: `~/kubernetes-learning-labs`.
3.  **Objetivo:** Dominio Local (Fases I-IV). La Fase V es opcional y de pago (Nube).

---

## 🧹 FASE 0: Limpieza Total (Preparación de Repetibilidad)

**Propósito:** Garantizar un entorno de **Estado Cero** (`State Zero`).

| Paso | Directorio | Comando | Instrucción Crítica |
| :--- | :--- | :--- | :--- |
| **0.1. Reset Local** | `~/kubernetes-learning-labs` | `./SCRIPTS/reset_minikube.sh` | **CRÍTICO:** Elimina Minikube y todo el estado de K8s anterior. |
| **0.2. Reset Bash** | (Terminal WSL) | (Cerrar y abrir sesión) | **CRÍTICO:** Necesario para activar los permisos de Docker sin `sudo`. |
| **0.3. Limpieza Nube** | `~/kubernetes-learning-labs` | `./SCRIPTS/08_cleanup_tf_backend.sh` | **FINOPS:** Limpia el Storage Account de Azure (si lo usaste antes). |

---

## FASE I: Setup Local y Arquitectura (Nivel 1)

**Propósito:** Instalar herramientas y levantar el clúster básico.

| Paso | Directorio | Comando | Validación y Logro |
| :--- | :--- | :--- | :--- |
| **I.1. Setup Base** | `~/kubernetes-learning-labs` | `./SCRIPTS/01_minikube_setup.sh` | Docker, kubectl y minikube instalados. |
| **I.2. Iniciar K8s** | `~/kubernetes-learning-labs` | `./SCRIPTS/02_minikube_start_check.sh` | **Logro:** Nodo `minikube` en estado **`Ready`**. (Clúster estable). |

---

## FASE II: Resiliencia y Objetos Core (Nivel 2)

**Propósito:** Desplegar una aplicación web y validar la **Auto-curación SRE**.

| Paso | Directorio | Comando | Logro Esperado |
| :--- | :--- | :--- | :--- |
| **II.1. Desplegar App** | `~/kubernetes-learning-labs` | `./SCRIPTS/02_lab_deploy.sh` | Deployment (`replicas: 3`) y Service (`NodePort`) creados. Pods en `ContainerCreating`. |
| **II.2. Validación** | `~/kubernetes-learning-labs` | `kubectl get pods -l app=web-hello` | **Logro:** 3 Pods en estado **`Running`**. |
| **II.3. Prueba SRE** | `~/kubernetes-learning-labs` | `kubectl delete pod <cualquier-nombre-de-pod>` | **CRÍTICO:** El Controller Manager crea un Pod nuevo inmediatamente para reemplazar al eliminado. |

---

## FASE III: DevSecOps y Persistencia (Nivel 3)

**Propósito:** Implementar seguridad de credenciales y almacenamiento de datos.

| Paso | Directorio | Comando | Logro Esperado |
| :--- | :--- | :--- | :--- |
| **III.1. Config/Env** | `~/kubernetes-learning-labs` | `echo "POSTGRES_DB=devops_db" > labs/lab_03_config_state/db_config.env` | Archivo `.env` creado. |
| **III.2. Crear Secret** | `~/kubernetes-learning-labs` | `kubectl create secret generic postgres-secret --from-literal=POSTGRES_USER=devops_user --from-literal=POSTGRES_PASSWORD='lab_password_123'` | **BP DevSecOps:** Secret creado. |
| **III.3. Desplegar DB** | `~/kubernetes-learning-labs` | `kubectl apply -f labs/lab_03_config_state/db-config-storage.yaml` | Deployment y **PVC** creados. |
| **III.4. Validación SRE** | `~/kubernetes-learning-labs` | `kubectl get pvc` | **Logro:** PVC en estado **`Bound`**. |
| **III.5. Cleanup** | `~/kubernetes-learning-labs` | `kubectl delete -f labs/lab_03_config_state/db-config-storage.yaml && kubectl delete secret postgres-secret` | Recursos de DB eliminados. |

---

## FASE IV: Networking y Observabilidad (Nivel 4)

**Propósito:** Acceso por dominio real y monitoreo visual.

| Paso | Directorio | Comando | Logro Esperado |
| :--- | :--- | :--- | :--- |
| **IV.1. Setup Ingress** | `~/kubernetes-learning-labs` | `minikube addons enable ingress` | Ingress Controller activo. |
| **IV.2. Despliegue Regla** | `~/kubernetes-learning-labs` | `kubectl apply -f labs/lab_04_ingress_monitor/ingress-web-app.yaml` | Regla Ingress creada. |
| **IV.3. Simular DNS** | `~/kubernetes-learning-labs` | `sudo vi /etc/hosts` **(Añadir: `$MINIKUBE_IP hello.devops.lab`)** | **BP Networking:** Dominio mapeado a Ingress Controller IP. |
| **IV.4. Prueba Final** | `~/kubernetes-learning-labs` | `curl http://hello.devops.lab` | **Logro:** Muestra el contenido HTML de la aplicación (Enrutamiento L7 exitoso). |
| **IV.5. Dashboard** | `~/kubernetes-learning-labs` | `minikube dashboard &` | Dashboard de K8s operativo (se abre en el navegador). |

---

## FASE V: Transición a la Nube (Opcional - Ver `RUNBOOK_MAESTRO.md`)

**NOTA FINOPS:** Esta fase incurre en costos. Solo ejecutar si se requiere la práctica avanzada de IaC en Azure AKS.
