#!/bin/bash
set -e

display_usage() {
    echo -e "Missing parameters."
    echo -e "Environment variable ARM_CLIENT_ID needs to be defined.\n"
}

if [ -z "$ARM_CLIENT_ID" ]
then
    display_usage
    exit 1
fi

echo "removing service principal $ARM_CLIENT_ID"
az ad sp delete --id $ARM_CLIENT_ID

echo "removing folders"
rm -rf ./.terraform
rm -f ./.terraform.lock.hcl
rm -f ./errored.tfstate
rm -f ./planfile
rm -f ./terraform.tfstate.backup
rm -f ./terraform.tfstate
rm -f ./.env
