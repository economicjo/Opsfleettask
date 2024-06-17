# Terraform EKS with Karpenter

This Terraform module deploys an EKS cluster with Karpenter for autoscaling. It supports both x86 and ARM64 instances.

## Usage

1. Update the variables in `variables.tf`.
2. Run `terraform init` to initialize the configuration.
3. Run `terraform apply` to create the resources.

## Testing

To run a pod on x86 or ARM64 nodes, use the following commands:

```sh
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