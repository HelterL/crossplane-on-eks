output "endpoint" {
  value = aws_eks_cluster.clustereks.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.clustereks.name
}