# 🔒 LAB 03: Gestión de Configuración y Persistencia (DevSecOps/SRE)

## 🎯 Objetivo del Laboratorio
Aprender a gestionar aplicaciones con estado (*Stateful*) utilizando los pilares de **Configuración, Credenciales y Persistencia** en Kubernetes. Esto asegura el **desacoplamiento (DevOps)**, la **seguridad (DevSecOps)** y la **confiabilidad de los datos (SRE)**.

## 🛠️ TAREA 3.1: Creación de ConfigMaps y Secrets (Práctica DevSecOps)

Los siguientes comandos crean los objetos de configuración fuera del Deployment, evitando exponer valores sensibles en el código IaC.

### 1. Creación del ConfigMap (Datos No Sensibles)
* **Comando:** `kubectl create configmap postgres-config --from-env-file=labs/lab_03_config_state/db_config.env`
* **Resultado:** `configmap/postgres-config created`
* **Propósito:** Contiene el nombre de la base de datos (`POSTGRES_DB=devops_db`).

### 2. Creación del Secret (Credenciales Sensibles)
* **Comando:** `kubectl create secret generic postgres-secret --from-literal=POSTGRES_USER=devops_user --from-literal=POSTGRES_PASSWORD='lab_password_123'`
* **Resultado:** `secret/postgres-secret created`
* **Propósito DevSecOps:** Almacena credenciales (usuario y contraseña) cifradas en Base64. Esto es preferible a poner contraseñas directamente en el YAML.

## 💾 TAREA 3.2: Despliegue con Persistencia (SRE)

El siguiente YAML (`labs/lab_03_config_state/db-config-storage.yaml`) define la solicitud de almacenamiento (`PVC`) y el Deployment de PostgreSQL, referenciando los objetos de configuración creados anteriormente.

\`\`\`yaml
---
# -----------------------------------------------------------------------------
# Componente 1: PersistentVolumeClaim (PVC) - Solicitud de Storage
# -----------------------------------------------------------------------------
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  labels:
    app: postgres-db
spec:
  # Mejor Práctica SRE: Garantiza que solo un Pod pueda escribir en el volumen.
  accessModes:
    - ReadWriteOnce 
  storageClassName: standard 
  resources:
    requests:
      storage: 2Gi # Solicitamos 2 Gigabytes de almacenamiento
---
# -----------------------------------------------------------------------------
# Componente 2: Deployment (PostgreSQL)
# -----------------------------------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
  labels:
    app: postgres-db
spec:
  replicas: 1 # Única réplica para evitar inconsistencia de datos (split-brain)
  selector:
    matchLabels:
      app: postgres-db
  template:
    metadata:
      labels:
        app: postgres-db
    spec:
      containers:
      - name: postgres-container
        image: postgres:16-alpine
        ports:
        - containerPort: 5432
        
        # --- Inyección de Configuración (DevSecOps) ---
        env:
          # Inyección desde ConfigMap (Configuración)
          - name: POSTGRES_DB
            valueFrom:
              configMapKeyRef:
                name: postgres-config
                key: POSTGRES_DB
          # Inyección desde Secret (Credenciales - No visibles en el YAML)
          - name: POSTGRES_USER
            valueFrom:
              secretKeyRef:
                name: postgres-secret
                key: POSTGRES_USER
          - name: POSTGRES_PASSWORD
            valueFrom:
              secretKeyRef:
                name: postgres-secret
                key: POSTGRES_PASSWORD
        
        # --- Montaje de Persistencia (SRE) ---
        volumeMounts:
        - mountPath: /var/lib/postgresql/data # Directorio donde PostgreSQL almacena datos
          name: postgres-storage
      
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
\`\`\`

## 🚀 TAREA 3.3: Validación de Persistencia y Configuración

### 1. Validación de Persistencia (SRE)
* **Comando:** `kubectl get pvc`
* **Resultado Clave:**
    ```
    NAME           STATUS   VOLUME...   CAPACITY...
    postgres-pvc   Bound    pvc-8a5b6bc9... 2Gi
    ```
* **Conclusión:** El estado **`Bound`** (Vinculado) confirma que la solicitud de volumen (`PVC`) fue satisfecha con un **PersistentVolume (PV)**. Esto garantiza que los datos de la base de datos no se perderán si el Pod se reinicia o es migrado.

### 2. Inspección de Inyección de Variables (DevSecOps/SRE)
* **Comando:** `kubectl describe pod -l app=postgres-db`
* **Resultado Clave:**
    * La sección `Environment` confirma la inyección de `POSTGRES_DB` (ConfigMap), `POSTGRES_USER` y `POSTGRES_PASSWORD` (Secret).
    * La sección `Mounts` confirma que la ruta `/var/lib/postgresql/data` está montada desde el volumen persistente (`postgres-storage`).
* **Conclusión:** Se valida la **separación de intereses** (DevOps) y la **seguridad de las credenciales** (DevSecOps).

---

## 📜 Guía Rápida (How-To) LAB 03

| Concepto Clave | Objeto K8s | Propósito / Beneficio | Comando de Validación |
| :--- | :--- | :--- | :--- |
| **Configuración** | **ConfigMap** | Almacena datos de configuración no sensibles, desacoplándolos del Deployment. | `kubectl describe configmap postgres-config` |
| **Credenciales** | **Secret** | Almacena credenciales de forma segura (Base64) para inyección. (DevSecOps) | `kubectl describe secret postgres-secret` |
| **Persistencia** | **PVC** | Solicita almacenamiento físico que sobrevive a la vida del Pod. (SRE) | `kubectl get pvc` |
| **Deployment con Estado** | **Deployment** | Despliega la aplicación y consume el Secret, ConfigMap y PVC. | `kubectl get deployment postgres-deployment` |
