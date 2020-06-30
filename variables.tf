variable "publickey" {
    type = string
}

variable "kubeconfig_aws_authenticator_command" {
    default = "aws-iam-authenticator"
}

variable "kubeconfig_aws_authenticator_env_variables" {
    type = string
}
