output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  value = data.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_arn" {
  value = data.aws_eks_cluster.cluster.arn
}