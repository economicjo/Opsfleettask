resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = "karpenter"
  values     = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "controller.clusterEndpoint"
    value = data.aws_eks_cluster.cluster.endpoint
  }

  set {
    name  = "controller.clusterCA"
    value = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }

  set {
    name  = "controller.serviceAccountName"
    value = "karpenter"
  }

  set {
    name  = "controller.iamRoleArn"
    value = var.node_role_arn
  }
}