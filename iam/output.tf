output "iam_role_policy_attach" {
  value = aws_iam_role_policy_attachment.devopseks-AmazonEKSClusterPolicy
}
output "iam_role_arn" {
  value = aws_iam_role.eksiam.arn
}
output "iam_role_arn_node" {
  value = aws_iam_role.eksnodeiam.arn
}
output "eks_policy_attach_workers" {
  value = aws_iam_role_policy_attachment.devopseks-AmazonEKSWorkerNodePolicy
}
output "eks_policy_attach_cni" {
  value = aws_iam_role_policy_attachment.devopseks-AmazonEKS_CNI_Policy
}
output "eks_policy_attach_ec2" {
  value = aws_iam_role_policy_attachment.devopseks-AmazonEC2ContainerRegistryReadOnly
}