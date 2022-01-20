# azure-bootstrap

This repo creates a storage account which is used for bootstrapping your
terraform deployments. It is integrate into **Github Actions** as CI/CD pipline.   
The storage account is later used for saving terraform state files.

## How to use this repo

### Pre-requesites

Make sure you have an azure service principal account. To create one you can use to following command in the azure command line tool.
Replace your-azure-subscription-id with your real Scription ID. Feel free to also adjust the value of the `--name` attribute.\
Otherwise you can configure a service principal using the Azure Portal. Make sure it has `Contributor` role in your Azure subscription.

```bash
# Login
az login

# Create service principal with Contributor role
az ad sp create-for-rbac \
--name="sp_plyg02" \
--role="Contributor" \
--scope="/subscriptions/your-azure-subscription-id" \
--sdk-auth \
> az_client_credentials.json
```
### Step 1: Adjust variables

Adjust variables in file [shared_vars.hcl](./shared_vars.hcl) for your Azure environment.
Documentation on each variable is inside the sample file.

```bash
# Edit the file
nano shared_vars.hcl
```
### Step 2: Enter azure credentials in `.env` file

Rename [env.sample](./env.sample) to `.env` and fill in your azure credentials.

### Step 3: Comment out `backend` configuration in [provider.tf](./provider.tf) for the initial build

Change:

```hcl
terraform {
  backend "azurerm" {
  }
}
```

to:

```hcl
// terraform {
//   backend "azurerm" {
//   }
// }
```

### Step 4: Run `build_initial.sh`

Before running the script make sure to `source` your `.env` file.  
This script creates the following azure resources:

- resource group
- storage account
- storage container (bucket)

```bash
source .env
./build_initial.sh
```

### Step 5: Migrate terraform state to storage account

Uncomment `backend` configuration in [provider.tf](./provider.tf).

Change:

```hcl
// terraform {
//   backend "azurerm" {
//   }
// }
```

to:

```hcl
terraform {
  backend "azurerm" {
  }
}
```

Copy the `ARM_ACCESS_KEY` for the newly created storage account from Azure portal to your `.env` file.

run:

```bash
source .env
./build.sh
```

### Step 6: Enter Azure credentials into Github

Before pushing your repo changes to Github, make sure to enter your Azure credentials into the `Action secrets` in Github.
Name the `Action secrets` exactly in correspondence to the entries in the `.env` file.

## Destroy

To destroy everything:

```bash
source .env
./destroy
```

This script errors at the end, because the storage account is deleted and terraform tries to access the state file. This is OK.

When you start over again, make sure to delete the following ignored files and folders:

- `.terraform/`
- `terraform.lock.hcl`
- `planfile`
- `terraform.tfstate.backup`
- `terraform.state`
