data "aws_availability_zones" "zone" {
  state = "available"
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/template/kubeconfig.tpl")

  vars = {
    endpoint                  = aws_eks_cluster.eks_cluster.endpoint
    cluster_auth_base64       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
    cluster_name              = aws_eks_cluster.eks_cluster.name
    aws_profile               = var.profile
  }
}