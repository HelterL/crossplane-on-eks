variable "cluster_name" {
  description = "nome do cluster"
}
variable "public_subnets_ids" {
  description = "ID das subnets publicas"
}
variable "private_subnets_ids" {
  description = "ID das subnets publicas"
}
variable "iam_role_arn" {
  description = "IAM Role ARN EKS"
}
variable "iam_role_policy_attach" {
  description = "associar politica ao Cluster"
}
variable "iam_node_arn" {
  description = "arn do node iam"
}
variable "eks_policy_attach_workers" {
  description = "associar politica workers"
}
variable "eks_policy_attach_cni" {
  description = "associar politicas cni"
}
variable "eks_policy_attach_ec2" {
  description = "associar politica ec2"
}
