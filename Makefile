deploy: terraform-apply update-eks
addons : metric-server calico

terraform-apply:
	cd ./terraform && terraform apply --auto-approve

update-eks:
	aws eks --region eu-west-1 update-kubeconfig --name eks-cluster --profile d2si
	gsed -i '$a \     \ env:\n \     \- name: AWS_PROFILE\n \      \ value: d2si' /Users/pierre.poree/.kube/config

metric-server:
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
calico:
	kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.6/config/v1.6/calico.yaml

destroy:
	cd ./terraform && terraform destroy --auto-approve
	rm /Users/pierre.poree/.kube/config