# Helper Scripts

## Quickstart

### build

```bash
az login
```

Create service principal and write credentials to `.env` file.

```bash
# Example:
./scripts/az_sp_create_to_env.sh \
--subscription 4cb91491-d3f9-4462-8526-1155333145e3 \
--name sp_plyg02 \
--role Owner
```

Script to assign API Permission `Directory.Read.All` to service principal, if necessary.

```bash
./scripts/az_sp_assign_directory_read.sh
```

Comment out:  
Change in [provider.tf](../provider.tf) from:

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

build initial with local terraform state

```bash
source .env
./build_initial.sh
```

copy storage access key to `.env`

```bash
echo "export ARM_ACCESS_KEY=$(terraform output storage_account_primary_access_key)" >> .env
```

undo comment out in [provider.tf](../provider.tf)

```bash
git restore provider.tf
```

build and migrate terraform state to storage container

```bash
source .env
./build.sh
```

### destroy

Delete service principal and delete terraform files

```bash
source .env
./destroy.sh
./scripts/az_sp_delete_from_env.sh
```
