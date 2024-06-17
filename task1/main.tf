provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

resource "aws_eks_node_group" "graviton_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "graviton-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["m6g.large"]

  ami_type = "AL2_ARM_64"
}

resource "aws_eks_node_group" "x86_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "x86-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["m5.large"]

  ami_type = "AL2_x86_64"
}

module "karpenter" {
  source = "./karpenter"
}