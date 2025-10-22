# Set the Subscription
export ARM_SUBSCRIPTION_ID="88888d09-c09d-4578-ab0d-731f655d24ef"

# Set the application/environment
export TF_VAR_application_name="network"
export TF_VAR_environment_name="dev"

# Set Variables for the Backend
export BACKEND_USE_CLI=true
export BACKEND_USE_AZUREAD_AUTH=true
export BACKEND_TENANT_ID="9e2fa0ed-a2ae-45f7-8ac9-302a462fcd0e"
export BACKEND_STORAGE_ACCOUNT="stbazi0r"
export BACKEND_STORAGE_CONTAINER="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

# Run terraform
terraform init \
    -backend-config="use_cli=${BACKEND_USE_CLI}" \
    -backend-config="use_azuread_auth=${BACKEND_USE_AZUREAD_AUTH}" \
    -backend-config="tenant_id=${BACKEND_TENANT_ID}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform