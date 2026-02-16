# Kubernetes/Kustomize Code Review Reference

## Priority Focus
- Security (RBAC, pod security, secrets)
- Resource management
- High availability patterns
- Kustomize best practices

## Pod Security

### Security Context
```yaml
# Flag: Missing security context
spec:
  containers:
    - name: app
      image: myapp:latest  # Missing securityContext!

# GOOD: Restrictive security context
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
  containers:
    - name: app
      image: myapp:latest
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop:
            - ALL
```

### Pod Security Standards
```yaml
# Flag: Privileged containers
securityContext:
  privileged: true  # Almost never needed!

# Flag: Host namespace access
hostNetwork: true   # Security risk
hostPID: true       # Security risk
hostIPC: true       # Security risk

# Flag: Writable root filesystem without justification
readOnlyRootFilesystem: false
```

### Image Security
```yaml
# BAD: Latest tag
image: nginx:latest  # Non-deterministic!

# GOOD: Specific version or digest
image: nginx:1.25.3
image: nginx@sha256:abc123...

# Flag: Images from untrusted registries
image: random-registry.io/unknown-image

# GOOD: From trusted registry
image: gcr.io/my-project/my-app:v1.2.3
```

## Resource Management

### Always Specify Resources
```yaml
# BAD: No resource limits
containers:
  - name: app
    image: myapp:v1

# GOOD: Explicit resources
containers:
  - name: app
    image: myapp:v1
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "500m"
```

### Resource Guidelines
```yaml
# Flag: Limits much higher than requests (overcommit risk)
resources:
  requests:
    memory: "64Mi"
  limits:
    memory: "4Gi"  # 64x overcommit!

# Flag: Missing memory limit (OOM killer target)
resources:
  limits:
    cpu: "1"  # No memory limit!

# Consider: CPU limits can cause throttling
# Sometimes requests-only for CPU is preferred
```

## High Availability

### Replica Count
```yaml
# Flag: Single replica in production
replicas: 1  # No HA!

# GOOD: Multiple replicas
replicas: 3

# GOOD: With PodDisruptionBudget
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: app-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: myapp
```

### Pod Anti-Affinity
```yaml
# Spread pods across nodes
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: myapp
          topologyKey: kubernetes.io/hostname
```

### Probes
```yaml
# Flag: Missing probes
containers:
  - name: app
    image: myapp:v1
    # No probes!

# GOOD: All probes configured
containers:
  - name: app
    image: myapp:v1
    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
    startupProbe:
      httpGet:
        path: /healthz
        port: 8080
      failureThreshold: 30
      periodSeconds: 10
```

## Secrets and ConfigMaps

### Secret Handling
```yaml
# BAD: Secrets in plain manifests
apiVersion: v1
kind: Secret
metadata:
  name: db-creds
stringData:
  password: "supersecret"  # Committed to git!

# GOOD: Use external secrets operator or sealed secrets
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-creds
spec:
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: db-creds
  data:
    - secretKey: password
      remoteRef:
        key: database/credentials
        property: password
```

### Environment Variables
```yaml
# Prefer secretKeyRef over plain values
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-creds
        key: password

# Use configMapKeyRef for non-sensitive config
env:
  - name: LOG_LEVEL
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: log_level
```

## RBAC

### Least Privilege
```yaml
# Flag: Overly permissive rules
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]  # Cluster admin!

# GOOD: Minimal permissions
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list"]
```

### Service Account
```yaml
# Flag: Using default service account
# (implicitly uses default if not specified)

# GOOD: Dedicated service account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
automountServiceAccountToken: false  # Unless needed
---
spec:
  serviceAccountName: app-sa
```

## Kustomize Best Practices

### Directory Structure
```
base/
├── kustomization.yaml
├── deployment.yaml
├── service.yaml
└── configmap.yaml
overlays/
├── dev/
│   ├── kustomization.yaml
│   └── patches/
├── staging/
│   ├── kustomization.yaml
│   └── patches/
└── prod/
    ├── kustomization.yaml
    └── patches/
```

### Kustomization Patterns
```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
commonLabels:
  app: myapp

# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
namePrefix: prod-
namespace: production
patches:
  - path: patches/deployment-replicas.yaml
  - path: patches/resources.yaml
configMapGenerator:
  - name: app-config
    literals:
      - LOG_LEVEL=warn
```

### Strategic Merge Patches
```yaml
# patches/deployment-replicas.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp  # Must match base
spec:
  replicas: 5
```

### JSON Patches (for precise changes)
```yaml
# kustomization.yaml
patches:
  - target:
      kind: Deployment
      name: myapp
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 5
```

## Common Pitfalls

- Labels/selectors mismatch between Deployment and Service
- Missing namespace in manifests
- Hardcoded values that should be parameterized
- ConfigMap/Secret changes not triggering pod restart
- Missing `imagePullPolicy: Always` with mutable tags
- NodePort services in production (use LoadBalancer/Ingress)

## Security Checklist

- [ ] No secrets in plain manifests
- [ ] SecurityContext with non-root user
- [ ] ReadOnlyRootFilesystem where possible
- [ ] Network policies defined
- [ ] Resource limits set
- [ ] RBAC follows least privilege
- [ ] Dedicated service accounts
- [ ] Image tags are immutable
- [ ] No privileged containers
- [ ] No host namespace access

## Documentation Standards

```yaml
# Include metadata annotations
metadata:
  name: myapp
  annotations:
    description: "Main application deployment"
    owner: "platform-team"
    repo: "github.com/org/myapp"
```
