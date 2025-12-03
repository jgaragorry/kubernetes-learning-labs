# 🌐 LAB 04: Networking Avanzado (Ingress) y Observabilidad (SRE)

## 🎯 Objetivo
Implementar enrutamiento L7 por nombre de dominio (Ingress) y activar la visibilidad del clúster (Dashboard).

## 🛠️ TAREA 4.2: Implementación de Ingress

**Archivos:** `labs/lab_04_ingress_monitor/ingress-web-app.yaml` (define la regla de Ingress).

| Paso | Comando | Observación Clave |
| :--- | :--- | :--- |
| **Setup** | `minikube addons enable ingress` | Instala el Ingress Controller (nginx) en el clúster. |
| **Simulación DNS** | `sudo vi /etc/hosts` | Se añade la línea `MINIKUBE_IP hello.devops.lab` para simular la resolución de DNS. |
| **Validación Ingress** | `kubectl get ingress` | Muestra la regla con `HOSTS: hello.devops.lab`. |
| **Prueba Final** | `curl http://hello.devops.lab` | **Resultado:** Muestra la página HTML del servidor Nginx del Pod, confirmando el enrutamiento L7. |

**Conclusión Networking:** El Ingress Controller enruta el tráfico basado en el nombre de host, una **Mejor Práctica** superior a la exposición directa por puerto.

## 📈 TAREA 4.4: Activación del Dashboard

| Acción | Comando | Propósito (Observabilidad SRE) |
| :--- | :--- | :--- |
| **Activación** | `minikube dashboard &` | Inicia el proxy y abre la interfaz gráfica. |
| **Uso SRE** | (Navegación) | Proporciona visibilidad del estado de salud (`Running`, `Ready`), uso de recursos (CPU/Memoria) y logs visualmente. |

---
