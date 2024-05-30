resource "aws_eks_node_group" "devopseks-nodes" {
  cluster_name    = aws_eks_cluster.clustereks.name
  node_group_name = "Nodes"
  node_role_arn   = var.iam_node_arn
  subnet_ids      = var.private_subnets_ids
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }
tags = {
  "Name" : "${var.cluster_name}-node"
}

  depends_on = [
    var.eks_policy_attach_workers,
    var.eks_policy_attach_cni,
    var.eks_policy_attach_ec2,
  ]
}