#!/bin/bash
set -e
shared_vars_file=shared_vars.hcl

terraform init
terraform validate
terraform plan -var-file $shared_vars_file -input=false -out=planfile
terraform apply -auto-approve planfile
