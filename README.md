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

## in this what we # COMPLETED TOPICS ✅

```yaml
- kubernetes_basics:
      description: "Node vs Pod IPs, Deployment, Service types"
      concepts_learned:
        - Node = physical/virtual machine IP
        - Pod = ephemeral container with dynamic IP
        - Deployment = manages Pods, desired state
        - ClusterIP = internal-only Service
        - NodePort = exposes Service on Node IP + port
        - LoadBalancer = external VIP entry
      hands_on:
        - "kubectl get pods, get svc, get deployments"
        - "kubectl apply -f deployment.yaml"
        - "kubectl delete pod / deployment"
        - "Observe Deployment auto-heal"
      jokes:
        - "Deployment = boss 🎩, Pods = employees 🕺💃, delete pod = firing temporary, Deployment rehires 😎"
        - "NodePort = bouncer 🚪, ClusterIP = invite-only party 🏠, LoadBalancer = VIP red carpet 🌉"

  - pod_lifecycle:
      description: "Pods are ephemeral, Deployment ensures desired state"
      hands_on:
        - "kubectl delete pod <pod-name> → see new pod pop up"
      joke:
        - "Fire employees ❌ → boss hires again. Fire the boss ✅ → everyone goes home 🏠😂"

  - internal_pod_communication:
      description: "Pods talk using Service DNS, never raw Pod IPs"
      example:
        - "http://user-service.default.svc.cluster.local:3000/api/users"
      rule_of_thumb: "Always use ClusterIP + selector for inter-pod communication"

  - multiple_env:
      description: "Created dev & staging namespaces"
      hands_on:
        - "kubectl get all -n dev / staging"
        - "Services exposed using NodePort per namespace"
      example_access:
        - dev: "http://192.168.29.13:32051/api/hello"
        - staging: "http://192.168.29.13:32052/api/hello"

  - load_testing_curl:
      description: "Check pod distribution using repeated curl"
      command:
        - "for i in {1..10}; do curl <NodeIP>:<NodePort>/api/hello; echo; done"
      outcome: "Shows which pod handled request, random per request"
```

## For example to see the response form pods

```bash
for i in {1..10}; do
  curl http://192.168.29.13:32051/api/hello
  echo
done
```
