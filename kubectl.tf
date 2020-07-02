resource "local_file" "kubeconfig" {
  content = data.template_file.kubeconfig.rendered
  filename = "/Users/pierre.poree/.kube/config"
  file_permission = "0644"
  directory_permission = "0755"
}