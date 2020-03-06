resource "aws_eks_node_group" "eks_node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.prefix}-node"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.subnet.*.id
  ami_type        = "AL2_x86_64"
  disk_size       = 20
  instance_types  = ["t3.micro"]
  remote_access {
      ec2_ssh_key = aws_key_pair.keypair.key_name
      source_security_group_ids = [aws_security_group.node.id]
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_security_group.node,
  ]
}

resource "aws_security_group" "node" {
   name = "${local.prefix}-node-sg"
   vpc_id = aws_vpc.vpc.id
  
   ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}