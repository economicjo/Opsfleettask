# Restricting Database Access from Kubernetes

This guide explains how to restrict access to MongoDB and PostgreSQL databases from services running on Kubernetes.

## Network Policies

Use Kubernetes Network Policies to restrict access:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-db-access
spec:
  podSelector:
    matchLabels:
      app: your-app
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: db-access
      ports:
        - protocol: TCP
          port: 27017  # MongoDB
        - protocol: TCP
          port: 5432  # PostgreSQL