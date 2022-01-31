#!/bin/bash

# make sure ARM_SUBSCRIPTION_ID is available
# export ARM_SUBSCRIPTION_ID="fba7de9f-2fe0-473c-abdc-23a5e1a3df20"

display_usage() {
    echo -e "Invalid parameters."
    echo -e "\nUsage: $0 --subscription [azure_subscription_id] --name [service principal name] --role [Owner|Contributor] \n"
    echo -e "Example: $0 --subscription 4cb91491-d3f9-4462-8526-1155333145e3 --name sp_plyg02 --role Owner \n"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--subscription)
    SUBSCRIPTION="$2"
    shift # past argument
    shift # past value
    ;;
    -n|--name)
    NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--role)
    ROLE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

ARM_SUBSCRIPTION_ID=${SUBSCRIPTION}
ARM_CLIENT_NAME=${NAME}
ARM_CLIENT_ROLE=${ROLE}

if [ -z "$ARM_SUBSCRIPTION_ID" ]
then
    display_usage
    exit 1
fi

if [ -z "$ARM_CLIENT_NAME" ]
then
    display_usage
    exit 1
fi
if [ -z "$ARM_CLIENT_ROLE" ]
then
    display_usage
    exit 1
fi


az_sp_json=`az ad sp create-for-rbac \
--name="${ARM_CLIENT_NAME}" \
--role="${ARM_CLIENT_ROLE}" \
--scope="/subscriptions/${ARM_SUBSCRIPTION_ID}" \
--years=2`

ARM_CLIENT_ID=`echo $az_sp_json | jq -r '.appId'`
ARM_CLIENT_SECRET=`echo $az_sp_json | jq -r '.password'`
ARM_TENANT_ID=`echo $az_sp_json | jq -r '.tenant'`

if [ -f ".env" ]; then
    rm -f .env
fi

echo "export ARM_SUBSCRIPTION_ID=\"$ARM_SUBSCRIPTION_ID\"" >> .env
echo "export ARM_CLIENT_ID=\"$ARM_CLIENT_ID\"" >> .env
echo "export ARM_CLIENT_SECRET=\"$ARM_CLIENT_SECRET\"" >> .env
echo "export ARM_TENANT_ID=\"$ARM_TENANT_ID\"" >> .env
# echo "export ARM_ACCESS_KEY=\"$ARM_ACCESS_KEY\"" >> .env
