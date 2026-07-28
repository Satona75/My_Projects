# Script to create resource group then run a Bicep file to deploy resources within it

# Variables
$resourceGroupName = "monitoring_rg"
$location = "uk south"

# Connect to Azure
write-host "Connecting to Azure" -ForegroundColor Green
Connect-AzAccount

# Create Resource Group
write-host "Creating Resource Group $resourceGroupName" -ForegroundColor Green
try {
    New-AzResourceGroup -ResourceGroupName $resourceGroupName -Location $location -ErrorAction Stop -Verbose
}
catch {
    write-host "Resource Group $resourceGroupName failed to deploy" -ForegroundColor Red
    write-host $_.Exception.Message -ForegroundColor Red
}

# Deploy Resources using Bicep
write-host "Deploying Resources in the Resource Group $resourceGroupName" -ForegroundColor Green
New-AzResourceGroupDeployment -ResourceGroupName 'monitoring_rg' -TemplateFile 'c:\Users\Nick Sackey\Documents\Scripts\My_Projects\Bicep\Monitoring\main.bicep' -TemplateParameterfile 'c:\Users\Nick Sackey\Documents\Scripts\My_Projects\Bicep\Monitoring\main-parameters.json' -Verbose