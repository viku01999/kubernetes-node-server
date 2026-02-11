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