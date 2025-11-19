#!/bin/bash
# Assign Entra ID user to a group using Azure CLI

user="$INPUT_USER"
group="$INPUT_GROUP"

echo "Logging into Azure..."
az login --service-principal \
  --username "$AZURE_CLIENT_ID" \
  --password "$AZURE_CLIENT_SECRET" \
  --tenant "$AZURE_TENANT_ID"

# Get user object ID
userObjectID=$(az ad user show --id "$user" --query id --output tsv)

# Add user to group
echo "Adding user $user to group $group"
