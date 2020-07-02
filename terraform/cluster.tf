resource "aws_eks_cluster" "eks_cluster" {
  name     = local.prefix
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.subnet.*.id
    security_group_ids = [aws_security_group.cluster.id]
  }
  enabled_cluster_log_types = ["api", "authenticator"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_security_group.cluster,
  ]
}

resource "aws_security_group" "cluster" {
   name = "${local.prefix}-sg"
   vpc_id = aws_vpc.vpc.id
   egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_security_group_rule" "ingress_https_to_node" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
}