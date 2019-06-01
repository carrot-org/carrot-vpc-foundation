plan:
	terraform init
	terraform plan -out plan.tfplan
apply:
	terraform init
	terraform apply -input=false -auto-approve plan.tfplan