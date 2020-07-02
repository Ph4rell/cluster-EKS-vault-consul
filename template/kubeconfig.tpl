apiVersion: v1

clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cluster_auth_base64}
  name: kubernetes

contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws

current-context: aws
kind: Config
preferences: {}

users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
      - token
      - -i
      - ${cluster_name}
      env:
      - name: AWS_PROFILE
        value: ${aws_profile}