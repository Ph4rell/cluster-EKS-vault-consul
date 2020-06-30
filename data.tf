data "aws_availability_zones" "zone" {
  state = "available"
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/template/kubeconfig.tpl")

  vars = {
    endpoint                  = aws_eks_cluster.eks_cluster.endpoint
    cluster_auth_base64       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
    kubeconfig_name           = local.prefix 
    aws_authenticator_command = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args = "        - ${join(
      "\n        - ",
      formatlist("\"%s\"", ["token", "-i", aws_eks_cluster.eks_cluster.name]),
    )}"
    aws_authenticator_env_variables = "      env:\n${join(
      "\n",
      data.template_file.aws_authenticator_env_variables.*.rendered,
    )}"
}
}

data "template_file" "aws_authenticator_env_variables" {
  count = length(var.kubeconfig_aws_authenticator_env_variables)

  template = <<EOF
        - name: $${key}
          value: $${value}
EOF

  vars = {
    value = values(var.kubeconfig_aws_authenticator_env_variables)[count.index]
    key   = keys(var.kubeconfig_aws_authenticator_env_variables)[count.index]
  }
}