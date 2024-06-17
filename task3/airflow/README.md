# Deploying Airflow on EKS

This guide shows how to deploy Airflow on an existing EKS cluster using the KubernetesExecutor.

## Prerequisites

1. Install Helm.
2. Add the Airflow Helm repository:

```sh
helm repo add apache-airflow https://airflow.apache.org
helm repo update