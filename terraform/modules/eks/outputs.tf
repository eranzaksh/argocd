output "eks_endpoint" {
    value = aws_eks_cluster.tf-eks.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.tf-eks.certificate_authority[0].data
}

output "cluster_name" {
  value = aws_eks_cluster.tf-eks.name
}