# Project-Unicorn

This CI/CD pipeline is designed to do 3 things:

1. Bootstrap a central storage account in each tenant to be used for storing the terraform state files and collecting VNet Flow Logs.
2. Enable Virtual Network Diagnostic Settings via Azure Policy. The policy is assigned at the root Management Group level to include in scope all client subscriptions. The policy automatically enables the diagnostic settings on any existing (and new) Virtual Networks from a tenant.
3. Scan all subscriptions (clients) and enable Flow Logs across all client VNETs (using Azure CLI command).
4. Disable legacy Network Security Group Flow Logs on all client NSGs (both tenants).
