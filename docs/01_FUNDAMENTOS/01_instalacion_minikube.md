# 📚 LAB 01: Instalación y Arquitectura del Clúster Local

## 🎯 Objetivo
Configurar el entorno de desarrollo local (WSL 2 / Ubuntu / minikube) y validar el entendimiento de los componentes esenciales del Control Plane y los Worker Nodes.

## 🛠️ TAREA 1.2: Instalación de Prerrequisitos (Docker y kubectl)

**Propósito:** Asegurar la base del sistema (Docker para el *runtime* y kubectl para la gestión).

| Paso | Comando de Instalación (Resumen) | Observación (DevSecOps) |
| :--- | :--- | :--- |
| **Docker** | `sudo apt install docker-ce...` | **Mejor Práctica:** Agregar usuario al grupo `docker` (`sudo usermod -aG docker $USER`). **Requiere re-login.** |
| **kubectl** | `curl -LO "https://dl.k8s.io/release/..."` | **DevSecOps:** Se valida la integridad del binario con `sha256sum`. |
| **minikube** | `sudo install minikube-linux-amd64 /usr/local/bin/minikube` | Instalación del binario. Se inicia con `minikube start --driver=docker`. |

## 🧠 TAREA 1.4: Análisis de la Arquitectura del Clúster

**Salida SRE:** `kubectl get nodes` muestra un nodo con rol `control-plane`.

| Componente del Control Plane | Función (SRE) |
| :--- | :--- |
| **etcd** | **Base de Datos:** Almacena el estado deseado y actual de *TODO* el clúster (la fuente de la verdad). |
| **Kube-APIServer** | **Puerta de Entrada:** Único punto de interacción (`kubectl`). Valida todas las llamadas REST. |
| **Controller Manager** | **Auto-Curación:** Observa el estado actual vs. el estado deseado y actúa para corregir (p.ej., levanta Pods caídos). |
| **Kube-Scheduler** | **Planificación:** Decide en qué nodo se ejecutará un nuevo Pod, basándose en recursos. |

---
