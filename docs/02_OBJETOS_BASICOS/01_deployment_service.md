# 📚 LAB 02: Despliegue, Service y Resiliencia (Objetos Core)

## 🎯 Objetivo del Laboratorio
Aprender a desplegar una aplicación web de forma **resiliente** utilizando el objeto **Deployment** y hacerla accesible externamente mediante un **Service** de tipo **NodePort**.

## 🛠️ Archivos de Infraestructura como Código (IaC)

Este laboratorio utiliza el siguiente archivo YAML, ubicado en `labs/lab_02_deploy_app/web-deployment-service.yaml`, el cual define tanto el Deployment como el Service.

### 1. Definición del Despliegue y Service (YAML)
\`\`\`yaml
---
# -----------------------------------------------------------------------------
# Componente 1: Deployment (Gestión de la Aplicación)
# -----------------------------------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-hello-deployment
  labels:
    app: web-hello
    env: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-hello
  template:
    metadata:
      labels:
        app: web-hello
    spec:
      containers:
      - name: web-hello-container
        image: nginxdemos/hello
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: "64Mi"
            cpu: "250m"
          requests:
            memory: "32Mi"
            cpu: "100m"
---
# -----------------------------------------------------------------------------
# Componente 2: Service (Exposición de la Aplicación)
# -----------------------------------------------------------------------------
apiVersion: v1
kind: Service
metadata:
  name: web-hello-service
  labels:
    app: web-hello
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30000
  selector:
    app: web-hello
\`\`\`

## 🚀 TAREA 2.2: Despliegue y Validación Inicial

El script de despliegue (\`./SCRIPTS/02_lab_deploy.sh\`) automatiza los siguientes comandos:

\`\`\`bash
kubectl apply -f labs/lab_02_deploy_app/web-deployment-service.yaml
kubectl get deployments,services -l app=web-hello
\`\`\`

1. Análisis de la Salida de Despliegue  
Deployment → 0/3 Ready, 3 Available → Fase de arranque, descarga de imagen y creación de Pods.  
Service (NodePort) → 8080:30000/TCP → Conectividad establecida, acceso externo vía puerto 30000.  
Pods → ContainerCreating → Running → Imagen descargada y contenedores ejecutándose.  

## 💥 TAREA 2.3: Prueba de Resiliencia (Auto-curación SRE)

La prueba valida la funcionalidad del Controller Manager de Kubernetes, asegurando que el estado actual coincida con el estado deseado (\`replicas: 3\`).

1. Estado ANTES de la Falla  
Deseado: 3 Pods  
Actual: 3 Pods Running/Ready  

2. Simulación de Falla  
\`\`\`bash
kubectl delete pod <NOMBRE_DEL_POD_ORIGINAL>
\`\`\`

3. Estado DESPUÉS de la Falla  
web-hello-deployment-85cc975f89-4jb2s → Running (nuevo Pod creado)  
web-hello-deployment-85cc975f89-s2s9v → Running (original)  
web-hello-deployment-85cc975f89-sxj9g → Running (original)  

**Conclusión SRE:** El Deployment garantiza confiabilidad. Kubernetes asegura resiliencia automática sin intervención humana.

## 📜 Guía Rápida (How-To) LAB 02

Resiliencia y Auto-curación → Deployment → Mantiene réplicas constantes → \`kubectl get deployments\`  
Unidad de Ejecución → Pod → Unidad efímera gestionada por Deployment → \`kubectl get pods -l app=web-hello\`  
Conectividad Externa → Service (NodePort) → IP y puerto estables para acceso → \`minikube service web-hello-service\`

