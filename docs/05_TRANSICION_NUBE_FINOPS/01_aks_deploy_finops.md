# ☁️ LAB 05: Despliegue en Azure AKS y Adaptación (FinOps/SRE)

## 🎯 Objetivo
Desplegar un clúster AKS con **Terraform (IaC)**, aplicar **FinOps** y **DevSecOps**, y adaptar la aplicación para usar un **LoadBalancer**.

## 🛠️ TAREA 5.11: Despliegue de Infraestructura (Terraform)

**Archivos Clave:** `labs/lab_05_azure_aks/terraform/` (contiene `aks.tf`, `network.tf`).

| Parámetro | Configuración | Impacto (FinOps/SRE) |
| :--- | :--- | :--- |
| **VM Size** | `Standard_B2s` | **FinOps:** VM de bajo costo para minimizar la facturación del laboratorio. |
| **Service CIDR** | `172.16.0.0/20` | **SRE/Networking Crítico:** Resuelve el error de conflicto de red (`ServiceCidrOverlap`) con la VNet de `10.0.0.0/16`. |
| **Tags** | `CostCenter=DevOps` | **FinOps:** Etiquetado aplicado al Resource Group para seguimiento y atribución de costos. |

## 🚀 TAREA 5.12: Validación Final del Despliegue en la Nube

**Acción:** Ejecutar `./deploy-aks.sh` (Configura `kubectl` y aplica `aks-web-app.yaml`).

| Validación | Resultado Clave | Conclusión SRE |
| :--- | :--- | :--- |
| **Conexión** | `kubectl get nodes` muestra el nodo `aks-systempool... Ready`. | `kubectl` se configuró correctamente. El clúster está listo. |
| **Service Cloud** | `kubectl get service web-hello-service-aks` muestra **EXTERNAL-IP** con una IP Pública (`X.X.X.X`). | **Éxito DevOps:** La adaptación a `type: LoadBalancer` funciona, y Azure provisiona el acceso público. |

**Lección Final (DevOps):** La transición del `Service` de `NodePort` (local) a **`LoadBalancer`** (nube) es el cambio clave para la portabilidad de las aplicaciones K8s entre entornos.

---
