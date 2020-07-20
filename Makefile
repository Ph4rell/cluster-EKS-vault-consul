deploy: terraform-apply update-eks

terraform-apply:
		cd ./terraform && terraform apply --auto-approve

update-eks:
		aws eks --region eu-west-1 update-kubeconfig --name eks-cluster --profile d2si