# 🎥 README_VIDEO_GUIDE.MD - Guía Maestra para el Video: Dominio de Kubernetes Local

Este documento desglosa el contenido y la explicación de cada fase del Workshop de Kubernetes (Fases 0 a IV) para un video o presentación técnica.

---

## 🎯 1. Visión Estratégica del Workshop

### A. ¿Por qué este Workshop?
Este taller no es solo sobre aprender comandos; es sobre adoptar la **metodología de la ingeniería moderna**. Está diseñado para transformar a un operador de comandos en un **Ingeniero de Confiabilidad (SRE)** y **DevOps** que prioriza la automatización, la resiliencia y la gestión segura del estado.

### B. Tecnologías Usadas y Justificación
| Tecnología | Rol | Justificación (BP - Mejor Práctica) |
| :--- | :--- | :--- |
| **WSL 2 / Ubuntu** | Entorno de Ejecución | Proporciona un ambiente Linux ligero y estable para simular un servidor real (DevOps). |
| **Docker** | Container Runtime | Motor esencial para construir y ejecutar los contenedores que orquesta Kubernetes. |
| **Minikube** | Clúster K8s Local | Es la herramienta más ligera para practicar la arquitectura **sin incurrir en costos** (FinOps/Práctica). |
| **kubectl** | Cliente de Gestión | La herramienta universal para interactuar con cualquier clúster K8s. |
| **Bash Scripts** | Automatización | Centraliza el setup y la limpieza, asegurando la **repetibilidad** y minimizando el error manual (SRE). |

### C. Nivel y Objetivo
* **Nivel:** Principiante Avanzado a Intermedio.
* **Objetivo Final:** Dominar los fundamentos operacionales de Kubernetes (Resiliencia, Persistencia, Networking) y demostrar la capacidad de **Troubleshooting SRE** y **Automatización DevOps**.

---

## 2. Desglose de Fases para el Video (Guion Detallado)

### 🧹 FASE 0: Limpieza Inicial (BP: Estado Conocido)

| Concepto | Comando Clave | Explicación del Comando y Argumentos |
| :--- | :--- | :--- |
| **Limpieza Total** | `minikube delete` | **Qué hace:** Elimina la máquina virtual de Minikube que corría el clúster. **Por qué:** Nos asegura que el clúster inicie limpio, sin configuraciones ni Pods residuales de sesiones anteriores (BP SRE). |
| **Reiniciar Entorno** | (Cerrar y Reabrir Terminal) | **Qué hace:** Aplica el cambio de permisos (`usermod -aG docker`) realizado en el script de instalación, permitiéndonos usar Docker sin `sudo` (BP DevSecOps/Usabilidad). |

---

### 🛠️ FASE I: Setup y Arquitectura (Comprender el Cerebro)

| Concepto | Comando Clave | Explicación del Comando y Argumentos |
| :--- | :--- | :--- |
| **Setup Base** | `./SCRIPTS/01_minikube_setup.sh` | **Qué hace:** Instala (`apt install`) `Docker` y descarga/mueve (`install`) el binario `kubectl` al `$PATH`. **Por qué:** `kubectl` es el único cliente que usaremos para hablar con K8s. |
| **Inicio K8s** | `./SCRIPTS/02_minikube_start_check.sh` | **Argumentos Clave:** `--driver=docker`, `--memory=4096mb`. **Qué hace:** Inicializa K8s usando Docker como motor y le asigna recursos específicos. **Logro:** El nodo `minikube` está en estado **`Ready`**. |
| **Arquitectura** | `kubectl get pods -n kube-system` | **Argumento Clave:** `-n kube-system` (apunta al namespace del sistema). **Qué hace:** Muestra los Pods que son el **Control Plane** (el cerebro): **etcd** (base de datos de estado) y **kube-apiserver** (la puerta de entrada). |

---

### 💥 FASE II: Resiliencia (Demostración de Auto-Curación SRE)

| Concepto | Comando Clave | Explicación del Comando y Argumentos |
| :--- | :--- | :--- |
| **Despliegue App** | `./SCRIPTS/02_lab_deploy.sh` | **Qué hace:** Aplica el YAML. El YAML define `replicas: 3` (estado deseado). Crea un **Deployment** (gestión inteligente) y un **Service** (`NodePort` 30000). |
| **Prueba de Falla** | `kubectl delete pod <nombre>` | **Qué hace:** Simula un fallo inesperado del contenedor. **Por qué:** Provoca un desajuste: el estado actual es 2, el deseado es 3. |
| **Validación SRE** | `kubectl get pods -l app=web-hello` | **Argumento Clave:** `-l app=web-hello` (filtra por etiqueta). **Logro:** Demuestra que el **Controller Manager** detecta la pérdida y **crea un nuevo Pod** para restaurar las 3 réplicas. |

---

### 🔒 FASE III: DevSecOps y Persistencia (Gestión del Estado)

| Concepto | Comando Clave | Explicación del Comando y Argumentos |
| :--- | :--- | :--- |
| **Separar Secretos** | `kubectl create secret generic postgres-secret --from-literal=KEY=VALUE` | **Argumento Clave:** `--from-literal=` (requiere `clave=valor`). **BP DevSecOps:** Almacenamos la contraseña en un objeto cifrado (Secret), **nunca** en el código fuente. |
| **Persistencia** | `kubectl apply -f db-config-storage.yaml` | **Qué hace:** Despliega PostgreSQL. El YAML pide una **PVC** (`PersistentVolumeClaim`) y **monta** el Secret/ConfigMap. |
| **Validación de Estado** | `kubectl get pvc` | **Qué hace:** Muestra el estado del volumen. **Logro:** El PVC debe estar **`Bound`** (vinculado). Si está *Bound*, los datos de la base de datos están seguros, incluso si el Pod muere (BP SRE). |

---

### 📈 FASE IV: Networking y Observabilidad (Acceso y Monitoreo)

| Concepto | Comando Clave | Explicación del Comando y Argumentos |
| :--- | :--- | :--- |
| **Enrutamiento L7** | `kubectl apply -f ingress-web-app.yaml` | **Qué hace:** Despliega un `kind: Ingress` que dice: "Si el host es `hello.devops.lab`, envíalo a mi Service". Requiere el *addon* `ingress` de Minikube. |
| **Simulación DNS** | `sudo vi /etc/hosts` + `curl` | **Qué hace:** Engaña al sistema operativo para que la IP del Ingress Controller (`minikube ip`) se asocie al dominio. **Logro:** `curl` devuelve la página HTML (prueba de enrutamiento L7 exitosa). |
| **Observabilidad** | `minikube dashboard &` | **Argumento Clave:** `&` (ejecuta en segundo plano). **Qué hace:** Lanza la GUI de monitoreo. **Propósito:** Permite el monitoreo visual del *health check* de los Pods y el consumo de recursos (BP SRE). |

---

## 💰 Costo del Workshop (FinOps)

* **Fases I-IV (Local):** **Costo Cero ($0 USD)**. Todo corre en tu máquina local.
* **Fase V (Nube):** El costo es estimado en **~$0.20 - $0.25 USD por hora** de ejecución del clúster AKS.

*Nota:* Para ejecutar el video, te recomiendo **limpiar Minikube (`minikube delete`)** antes de grabarlo para garantizar una experiencia de usuario final limpia y sin errores de estado.
