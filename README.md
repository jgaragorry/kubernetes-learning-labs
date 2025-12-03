# 🚀 Repositorio de Dominio de Kubernetes (K8s) - Labs y Workshop

## 📚 Misión y Propósito
Este repositorio contiene un plan de estudios **metódico, estructurado y progresivo** diseñado para dominar Kubernetes (K8s) desde los fundamentos de la orquestación de contenedores hasta la operación avanzada en la nube (Azure AKS).

El enfoque se centra en la aplicación de las **Mejores Prácticas de DevOps, DevSecOps, SRE (Ingeniería de Confiabilidad) y FinOps (Gestión de Costos)**.

---

## 🗺️ Estructura del Repositorio y Progresión de Complejidad

| Directorio | Nivel | Tema Central | Enfoque Principal | Complejidad |
| :--- | :--- | :--- | :--- | :--- |
| `docs/01_FUNDAMENTOS` | **1** | Instalación y Arquitectura Local | Entendimiento de la arquitectura Control Plane vs. Worker Node. | Básico (1/5) |
| `docs/02_OBJETOS_BASICOS` | **2** | Despliegue, Service y Resiliencia | Uso de Deployments para **Auto-curación (SRE)** y exposición de servicios. | Básico-Intermedio (2/5) |
| `docs/03_DEVSECOPS_SRE` | **3** | Configuración, Secrets y Persistencia | Desacoplamiento de credenciales (**DevSecOps**) y garantía de datos (*Stateful*). | Intermedio (3/5) |
| `docs/04_NETWORKING_OBSERVABILIDAD` | **4** | Ingress y Dashboard | Exposición de servicios por nombre (Ingress) y monitoreo visual (*Observabilidad SRE*). | Intermedio-Avanzado (4/5) |
| `docs/05_TRANSICION_NUBE_FINOPS` | **5** | AKS, Terraform e IaC Avanzada | Transición a servicios gestionados, **FinOps**, y resolución de conflictos de red. | Avanzado (5/5) |

---

## 🛠️ Guía de Automatización (SCRIPTS/)

Para asegurar la **repetibilidad (SRE)**, todos los entornos se gestionan mediante scripts de Bash.

| Script | Propósito y Comandos Principales | Mejores Prácticas Aplicadas |
| :--- | :--- | :--- |
| `01_minikube_setup.sh` | Instala Docker, `kubectl` y `minikube`. | **SRE:** Instala prerrequisitos de forma centralizada. **NOTA:** Requiere `re-login` después de la instalación de Docker. |
| `02_lab_deploy.sh` | Despliega los objetos del LAB 02 (Deployment/Service). | **DevOps:** Automatiza `kubectl apply`. |
| `07_create_tf_backend.sh` | Crea el Resource Group y el Storage Account de Azure para el backend de Terraform. | **DevSecOps/FinOps:** Implementación **Idempotente** (reutiliza si existe), fuerza **TLS 1.2** y aplica **etiquetas de costo** (`--tags`). |
| `deploy-aks.sh` | Ejecuta el ciclo completo de Terraform (`init`, `plan`, `apply`) y la configuración de `kubectl` para AKS. | **IaC:** Encapsula el ciclo de vida de la infraestructura. |
| `08_cleanup_tf_backend.sh` | Elimina el Resource Group del Backend. | **FinOps:** Destrucción completa para evitar cargos por almacenamiento de estado. |

---

## 🧠 Lecciones Aprendidas (Troubleshooting SRE Documentado)

Los siguientes puntos fueron los obstáculos más críticos superados, demostrando la fragilidad de la automatización y la importancia de la auditoría.

| Falla Identificada | Causa Raíz (SRE/DevOps) | Solución Final Aplicada | Lección Clave |
| :--- | :--- | :--- | :--- |
| **Error de Sintaxis Bash** | Uso de `\$VARIABLE` en lugar de `$VARIABLE` dentro de los scripts de Terraform y kubectl. | Eliminación de los *backslashes* (`\`) en el script `02_lab_deploy.sh` y otros. | **DevOps:** La sintaxis de Shell debe ser probada rigurosamente para garantizar la expansión de variables. |
| **Fallo Crítico de Networking** | **`ServiceCidrOverlapExistingSubnetsCidr`** (Error 400 de AKS). Azure intentó usar `10.0.0.0/16` para Servicios, lo que chocó con la VNet. | Modificación en `aks.tf` para usar un Service CIDR distinto (`172.16.0.0/20`) y añadir el `network_plugin="kubenet"`. | **Network SRE:** Los rangos de Service CIDR y Pod CIDR de K8s **DEBEN** ser únicos y no solaparse con la red virtual subyacente. |
| **Fallo Crítico de Terraform Init** | **`404 The specified container does not exist.`** | **Troubleshooting SRE:** Se forzó la creación manual del contenedor `tfstate` (`az storage container create --account-key ...`) para resolver el error de estado de Azure. | **SRE:** La infraestructura de *backend* debe ser verificada y estabilizada (a veces manualmente) antes de iniciar el IaC principal. |
| **Fallo de Seguridad del Backend** | El script de Bash falló al aplicar `Soft Delete` y `Versioning` por problemas de sintaxis con `az storage blob service-properties update`. | **Decisión SRE:** Se delegó la implementación de TLS 1.2 y Tagging a **Terraform** (Secciones 1 y 2 del script) ya que la sintaxis de Bash era inestable. | **DevSecOps:** No confiar en comandos inestables; usar la herramienta IaC (Terraform) para aplicar configuraciones de seguridad/SRE siempre que sea posible. |

---

## 💰 Guía FinOps (Financial Operations)

El clúster AKS es la principal fuente de costos.

| Recurso | Tipo de Cargo | Costo Estimado por Hora (LAB) |
| :--- | :--- | :--- |
| **AKS Worker Node** | VM `Standard_B2s` (1x) | ~$0.08 - $0.15 USD/hora |
| **AKS Control Plane** | Nivel Standard | ~$0.10 USD/hora |
| **Total Estimado** | - | **~$0.20 - $0.25 USD/hora** |

### 🚨 Regla de Oro (FinOps/SRE)
**Una vez que el laboratorio concluye, el clúster debe ser destruido.**

1.  **Destruir AKS, VNet, Subnet:** Elimina los recursos que generan costos por VM.
    ```bash
    cd labs/lab_05_azure_aks
    terraform -chdir=terraform destroy -auto-approve
    ```
2.  **Destruir Backend:** Elimina la Storage Account que guarda el archivo de estado.
    ```bash
    cd ../../
    ./SCRIPTS/08_cleanup_tf_backend.sh
    ```
---

¡Espero que esta documentación te sea de gran utilidad para el dominio total de Kubernetes! Si tienes alguna pregunta sobre el contenido del README, házmelo saber.
