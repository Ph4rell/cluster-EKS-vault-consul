resource "local_file" "kubeconfig" {
  content = data.template_file.kubeconfig.rendered
  filename = "${path.root}/kubeconfig"
  file_permission = "0644"
  directory_permission = "0755"
}