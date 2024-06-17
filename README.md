# Kubernetes Infrastructure and Application Deployment Guide
This repository contains Terraform code, Helm charts, and Kubernetes manifests to set up various components in an EKS cluster on AWS. The components include:

EKS Cluster with Karpenter for Autoscaling
Istio for mutual TLS between services
Airflow for data processing
GPU Slicing for AI workloads
Database access restrictions
Prerequisites
AWS CLI configured with necessary permissions
Terraform installed
Helm installed
kubectl installed and configured
Table of Contents
EKS Cluster with Karpenter
Istio Installation and Mutual TLS
Airflow Deployment
GPU Slicing
Database Access Restrictions
EKS Cluster with Karpenter
Description
Deploy an EKS cluster using Terraform with Karpenter for autoscaling. This setup supports both x86 and ARM64 instances.

Usage
Update the variables in terraform/variables.tf.
Navigate to the terraform directory.
Run terraform init to initialize the configuration.
Run terraform apply to create the resources.
Testing
To run a pod on x86 or ARM64 nodes, use the following commands:

sh
Copiar código
kubectl run --image=nginx --overrides='{
  "spec": {
    "nodeSelector": {
      "kubernetes.io/arch": "amd64"
    }
  }
}' x86-nginx

kubectl run --image=nginx --overrides='{
  "spec": {
    "nodeSelector": {
      "kubernetes.io/arch": "arm64"
    }
  }
}' arm64-nginx
## This will schedule x86-nginx on x86 nodes and arm64-nginx on ARM64 nodes.

Istio Installation and Mutual TLS
Description
Install Istio into an existing EKS cluster and configure mutual TLS between services.

Installation
Run the istio/install-istio.sh script to install Istio and enable sidecar injection:

sh
Copiar código
./istio/install-istio.sh
Apply the PeerAuthentication policy to enable mutual TLS:

sh
Copiar código
kubectl apply -f istio/peer-authentication.yaml
Secure Communication
The PeerAuthentication policy ensures that all services in the default namespace use mutual TLS for communication.

Airflow Deployment
Description
Deploy Airflow on an existing EKS cluster using the KubernetesExecutor.

DAG Deployment
To deploy new DAGs, create a ConfigMap with your DAG files:

sh
Copiar código
kubectl create configmap airflow-dags --from-file=dags/
Installation
Deploy Airflow using Helm:

sh
Copiar código
helm repo add apache-airflow https://airflow.apache.org
helm repo update
helm install airflow apache-airflow/airflow -f airflow/values.yaml
To upgrade an existing deployment with new DAGs:

sh
Copiar código
helm upgrade airflow apache-airflow/airflow -f airflow/values.yaml
This method ensures that new DAGs are deployed seamlessly to the Airflow cluster.

GPU Slicing
Description
Enable GPU Slicing on EKS clusters to optimize GPU usage.

Prerequisites
Install the NVIDIA device plugin:

sh
Copiar código
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.9.0/nvidia-device-plugin.yml
Enable GPU Slicing by configuring the device plugin and the Kubernetes scheduler.

Karpenter Integration
If using Karpenter, ensure GPU resources are properly recognized:

yaml
Copiar código
constraints:
  resources:
    requests:
      nvidia.com/gpu: 1
Example Deployment
yaml
Copiar código
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpu-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gpu-app
  template:
    metadata:
      labels:
        app: gpu-app
    spec:
      containers:
      - name: gpu-container
        image: nvidia/cuda:11.0-base
        resources:
          limits:
            nvidia.com/gpu: 1
Apply the deployment:

sh
Copiar código
kubectl apply -f gpu-deployment.yaml
Database Access Restrictions
Description
Restrict access to MongoDB and PostgreSQL databases from services running on Kubernetes.

Network Policies
Use Kubernetes Network Policies to restrict access:

yaml
Copiar código
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
Apply the policy:

sh
Copiar código
kubectl apply -f network-policy.yaml
Security Groups
Use AWS Security Groups to restrict access:

## Create a security group for your EKS nodes.
Allow inbound access only from specific security groups associated with your application pods.
sh
Copiar código
aws ec2 create-security-group --group-name EKSNodeSecurityGroup --description "EKS Node Security Group"
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 27017 --source-group sg-87654321
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 5432 --source-group sg-87654321
This ensures that only specific services can access the databases.

This README provides a comprehensive guide to setting up and configuring your EKS cluster and related services. Each section includes instructions for deployment, configuration, and verification to ensure everything is set up correctly.






