variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role to use for the node groups"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to use for the EKS node groups"
  type        = list(string)
}