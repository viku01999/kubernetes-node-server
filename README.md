# Kubernetes Resource Sharing: Requests & Limits 🏢💻

Welcome to your **Resource Sharing session**!  
Here, we’ll teach your “employees” (pods) **how much workload they can handle** so the boss (Deployment) can manage them efficiently.

---

## 📚 What You Will Learn

1. **Requests** – minimum CPU/memory guaranteed for each employee 🪑  
2. **Limits** – maximum CPU/memory an employee can handle 💪  
3. Why these are important for **HPA** (the boss needs metrics to decide when to hire more employees)

---

## 🔹 Hands-On Example

Add resource limits in your Deployment YAML:

```yaml
spec:
  containers:
    - name: kubernetes-node-server
      image: viku01999/kubernetes-node-server:3.0
      ports:
        - containerPort: 3000
      resources:
        requests:
          cpu: "100m"
          memory: "128Mi"
        limits:
          cpu: "500m"
          memory: "256Mi"
```

🔹 Fun Tip

Think of requests as the minimum desk space each employee gets.

Limits = maximum workload they can handle without burning out.

Boss (Deployment) + HPA rely on these numbers to make smart hiring/firing decisions.

---

## (Horizontal Pod Autoscaler)

```markdown
# Kubernetes HPA: Scaling Employees Automatically 🏢📈

Welcome to **Horizontal Pod Autoscaler (HPA)**!  
Here, the **boss** decides **when to hire or lay off employees** (pods) based on workload.

---

## 📚 What You Will Learn

1. How to **autoscale pods** based on CPU or memory usage  
2. How HPA works with **resource requests**  
3. Optional: scaling indirectly based on traffic  
4. Commands to create and monitor HPA

---

## 🔹 Hands-On Commands

```bash
# Scale automatically using HPA
kubectl autoscale deployment kubernetes-node-server \
  --cpu-percent=50 \
  --min=2 \
  --max=5 \
  -n dev

# Check HPA status
kubectl get hpa -o wide -n dev

# Delete HPA (Automatically)
kubectl delete hpa kubernetes-node-server-hpa -n dev

# Delete HPA (If create the manual)
kubectl scale deployment kubernetes-node-server --replicas=3 -n dev

# Suspend HPA scaling (min = max = current replicas)
kubectl patch hpa kubernetes-node-server-hpa -n dev \
  -p '{"spec":{"minReplicas":3,"maxReplicas":3}}'


# See live resource consuming by a pod
watch -n 1 "kubernetes-node-server-8495854996-fd7s9 -n dev"

```

🔹 How It Works

HPA = the boss observing employee workload

CPU usage rises → boss hires more employees

CPU usage drops → boss lets some employees go

Requests/limits are essential for HPA to make decisions

---

## (ConfigMaps & Secrets)

```markdown
# Kubernetes Configs & Secrets: Manuals & Vaults 🏢📋🏦

Welcome to **ConfigMaps & Secrets session**!  
Here, the boss keeps **employee manuals** and **vaults** so employees can work efficiently and securely.

---

## 📚 What You Will Learn

1. **ConfigMaps** – non-sensitive settings for employees (manuals, guidelines)  
2. **Secrets** – sensitive data employees need access to securely (vaults)  
3. How to **mount them in pods** without rebuilding images

---

## 🔹 Hands-On Commands

```bash
# Create a ConfigMap (manual)
kubectl create configmap my-config --from-literal=ENV=dev

# Create a Secret (vault)
kubectl create secret generic my-secret --from-literal=password=1234
```

## 💡 Formula HPA uses

```pgsql
Pod CPU usage (%) = (current CPU usage in millicores) / (CPU request in millicores) × 100
```

- Example:
  - Deployment pod request: cpu: 100m (0.1 CPU core)
  - Current pod usage: 50m (0.05 CPU core)
  - Usage = (50 / 100) × 100 = 50%

- So averageUtilization: 50 → HPA will try to scale up when average CPU usage across pods exceeds 50% of the requested CPU, not the total node CPU

---

# 🧠 1️⃣ Why Do We Need ConfigMaps & Secrets?

Perfect 👌 Let’s do a complete step-by-step masterclass on:

- ✅ What is ConfigMap
- ✅ What is Secret
- ✅ Why we use them
- ✅ How to create using YAML
- ✅ How to use in Deployment
- ✅ ENV vs Volume Mount
- ✅ Real production understanding

## Imagine your Node app has

```bash
process.env.ENV
process.env.DB_PASSWORD
process.env.PORT
```

Without ConfigMap/Secret:

- ❌ You hardcode inside Docker image
- ❌ Every environment (dev, prod) needs new image
- ❌ Secrets get stored in Git

*That is BAD practice.*

## 🎯 The Real Purpose

| Type      | Used For             | Example                  |
| --------- | -------------------- | ------------------------ |
| ConfigMap | Non-sensitive config | ENV, APP_NAME, LOG_LEVEL |
| Secret    | Sensitive data       | DB_PASSWORD, JWT_SECRET  |

They let you:

- ✔ Change configuration without rebuilding image
- ✔ Keep secrets separate
- ✔ Use same image in dev/prod
- ✔ Work cleanly with HPA scaling

## 🟢 2️⃣ Create ConfigMap (YAML Method – Best Practice)

Create file: `configmap.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: node-app-config
  namespace: dev
data:
  ENV: "dev"
  APP_NAME: "kubernetes-node-server"
  LOG_LEVEL: "debug"
  PORT: "3000"
```

Apply & Check::

```bash
kubectl apply -f configmap.yaml
kubectl get configmap -n dev
kubectl describe configmap node-app-config -n dev
```

## 🔐 3️⃣ Create Secret (YAML Method – Production Way)

Create: `secret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: node-app-secret
  namespace: dev
type: Opaque
stringData:
  DB_PASSWORD: "mySuperSecretPassword"
  JWT_SECRET: "myJwtSecretKey"
```

Apply & Check::

```bash
kubectl apply -f secret.yaml
kubectl get secret -n dev
kubectl describe secret node-app-secret -n dev
```

## 🚀 4️⃣ Use Them in Your Deployment (Environment Variables Method)

Now modify your deployment YAML.

Add this inside container section:

```bash
envFrom:
  - configMapRef:
      name: node-app-config
  - secretRef:
      name: node-app-secret
```

## 🔵 Final Updated Deployment YAML

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubernetes-node-server
  namespace: dev
  labels:
    app: kubernetes-node-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubernetes-node-server
  template:
    metadata:
      labels:
        app: kubernetes-node-server
    spec:
      containers:
        - name: kubernetes-node-server
          image: viku01999/kubernetes-node-server:3.0
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "256Mi"

          # 👇 Inject config + secrets
          envFrom:
            - configMapRef:
                name: node-app-config
            - secretRef:
                name: node-app-secret
```

Apply & Check::

```bash
# apply
kubectl apply -f dev-deployment.yaml

# Get pod name:
kubectl get pods -n dev

# Print env
kubectl exec -it <pod-name> -n dev -- printenv

# You should see: 🔍 What Happens Internally?

ENV=dev
APP_NAME=kubernetes-node-server
LOG_LEVEL=debug
PORT=3000
DB_PASSWORD=mySuperSecretPassword
JWT_SECRET=myJwtSecretKey

```

## 🟣 6️⃣ ENV vs Volume Mount (Very Important Concept)

There are 2 ways to use ConfigMap/Secret.

### ✅ Method 1: As Environment Variables (Most Common)

Pros:

- Easy
- Works great for Node/Java apps
- Simple

Used with:

```yaml
envFrom:
```

### ✅ Method 2: As Files (Volume Mount)

Used when:

- App expects config files
- SSL certificates
- JSON config
- Nginx config
- Database config files

## Example: Mount as Files

Add this inside container:

```yaml
volumeMounts:
  - name: config-volume
    mountPath: /app/config
  - name: secret-volume
    mountPath: /app/secret
```

**Add this under spec: (same level as containers):**

```yaml
volumes:
  - name: config-volume
    configMap:
      name: node-app-config

  - name: secret-volume
    secret:
      secretName: node-app-secret
```

## Final updated deployemnt.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubernetes-node-server
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubernetes-node-server
  template:
    metadata:
      labels:
        app: kubernetes-node-server
    spec:
      containers:
        - name: kubernetes-node-server
          image: viku01999/kubernetes-node-server:3.0

          # 🔹 Resource requests & limits
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "256Mi"

          # 🔹 Mount ConfigMap and Secret
          volumeMounts:
            - name: config-volume
              mountPath: /app/configmap
            - name: secret-volume
              mountPath: /app/secret

      # 🔹 Define volumes
      volumes:
        - name: config-volume
          configMap:
            name: node-app-config

        - name: secret-volume
          secret:
            secretName: node-app-secret
```

**Now inside container:**

```bash
/app/config/ENV
/app/config/LOG_LEVEL
/app/secret/DB_PASSWORD
/app/secret/JWT_SECRET
```

Note:- Each key becomes a file.

## 🧠 7️⃣ When To Use What?

| Use Case         | Use ENV | Use Volume |
| ---------------- | ------- | ---------- |
| Simple variables | ✅       | ❌          |
| Certificates     | ❌       | ✅          |
| JSON config file | ❌       | ✅          |
| DB password      | ✅       | ✅          |

## 🔥 8️⃣ Very Important Production Knowledge

**⚠ Secrets Are NOT Fully Secure**

They are:

- Base64 encoded (NOT encrypted by default)

For real production use:

- AWS Secrets Manager
- External Secrets Operator
- HashiCorp Vault

📦 Complete Structure

```bash
k8s/
├── deployment.yaml
├── configmap.yaml
└── secret.yaml
```
