.PHONY: plan apply destroy

plan:
	terraform plan -var-file=voltron.tfvars -out terraform.tfplan

apply:
	terraform apply -var-file=voltron.tfvars -auto-approve

destroy:
	terraform destroy -var-file=voltron.tfvars -auto-approve
