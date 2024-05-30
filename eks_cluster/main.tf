resource "aws_eks_cluster" "clustereks" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = var.public_subnets_ids
  }

  depends_on = [
    
  ]
}