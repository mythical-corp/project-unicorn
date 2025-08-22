# Project-Unicorn

The pipelines are designed to run per Azure tenant. <br>
For that, I have configured 2 GitHub Environments [tenant-A, tenant-B] that map to each Azure tenant.<br>
Each environment contains service principal details stored securely as GitHub Secrets. The details are used to authenticate the pipeline to Azure by impersonating a service principal in that tenant.
The service principal uses Entra ID configured Federated credentials and authorizes the workflow to use OIDC tokens:

```bash
permissions:
  id-token: write
  contents: read
```
<br>

## [bootstrap.workflow.yml](.github/workflows/bootstrap.workflow.yml)
First CI/CD pipeline is designed to bootstrap a central storage account in each Azure tenant to be used for storing the terraform state files and collecting VNet Flow Logs.



## [flow-logs.workflow.yml](.github/workflows/flow-logs.workflow.yml)
Second GitHub Actions workflow 'flow-logs.workflow.yml' is designed to do 3 things:

1. Enable Virtual Network Diagnostic Settings via Azure Policy. The policy is assigned at the root Management Group level to include in scope all client subscriptions. The policy automatically enables the diagnostic settings on any existing (and new) Virtual Networks from a tenant.

```bash
        - name: Deploy Azure Policy to enable Diagnostic Settings
          id: tfapply-azpolicy
          working-directory: terraform/diagnostic_settings
          env: 
            TF_VAR_management_group: ${{ env.ROOT_MG_GROUP }}
            TF_VAR_storage_account_id: ${{ steps.tfout.outputs.sa_id }}
          run: |
            terraform apply -auto-approve -input=false
```

2. Discover all subscriptions (clients) per tenant

```bash
    - name: Discover client subscriptions
          id: subs
          shell: bash
          run: |
            set -euo pipefail
            subs_json=$(az account list --all --query "[?tenantId=='${ARM_TENANT_ID}'].{id:id}" -o json)
            filtered=$(echo "$subs_json" | jq --arg central "$ARM_SUBSCRIPTION_ID" '[.[] | select(.id != $central)]')
            echo "subs=$filtered" >> "$GITHUB_OUTPUT"
```

2. Scan all subscriptions (clients) and enable Flow Logs across all client VNETs (using Azure CLI command).
3. Disable legacy Network Security Group Flow Logs on all client NSGs (both tenants).
