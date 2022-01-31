#!/bin/bash
set -e

display_usage() {
    echo -e "Missing parameters."
    echo -e "Environment variable ARM_CLIENT_ID needs to be defined.\n"
}

# https://docs.microsoft.com/en-us/cli/azure/ad/app/permission?view=azure-cli-latest

# Microsoft Graph:
# az ad sp show --id 00000003-0000-0000-c000-000000000000

#     {
#       "allowedMemberTypes": [
#         "Application"
#       ],
#       "description": "Allows the app to read group properties and memberships, and read the calendar and conversations for all groups, without a signed-in user.",
#       "displayName": "Read all groups",
#       "id": "5b567255-7703-4780-807c-7be8301ae99b",
#       "isEnabled": true,
#       "value": "Group.Read.All"
#     }
#     {
#           "allowedMemberTypes": [
#             "Application"
#           ],
#           "description": "Allows the app to read data in your organization's directory, such as users, groups and apps, without a signed-in user.",
#           "displayName": "Read directory data",
#           "id": "7ab1d382-f21e-4acd-a863-ba3e13f7da61",
#           "isEnabled": true,
#           "value": "Directory.Read.All"
#      }

source .env

if [ -z "$ARM_CLIENT_ID" ]
then
    display_usage
    exit 1
fi

echo "assigning app permission to $ARM_CLIENT_ID"
az ad app permission add \
--id $ARM_CLIENT_ID \
--api "00000003-0000-0000-c000-000000000000" \
--api-permissions "7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role"

echo "Sleeping for 5 sec."
sleep 5

echo "granting app permission to $ARM_CLIENT_ID"
az ad app permission grant \
--id $ARM_CLIENT_ID \
--api "00000003-0000-0000-c000-000000000000"

echo "Sleeping for 10 sec."
sleep 10

echo "consent app permission to $ARM_CLIENT_ID"
az ad app permission admin-consent \
--id $ARM_CLIENT_ID
