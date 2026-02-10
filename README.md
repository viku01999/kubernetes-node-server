# 🚀 Step 1: Two Environments — Dev & Staging

```bash
# Create dev and staging namespaces
kubectl create namespace dev
kubectl create namespace staging

# Verify
kubectl get ns

```

## Bacics command for this branch

```bash
# Dev
kubectl apply -f dev-deployment.yaml
kubectl apply -f dev-service.yaml

# Staging
kubectl apply -f staging-deployment.yaml
kubectl apply -f staging-service.yaml

# Check pods in each namespace
kubectl get pods -n dev
kubectl get pods -n staging

# Check services in each namespace
kubectl get svc -n dev
kubectl get svc -n staging
```
