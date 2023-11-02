# Type: PowerShell Script
# Author: Matt Lunzer
# Date: 2021-10-12
# Description: This script will unlink the ESU license from a Hybrid Azure AD joined machine.
# Usage: Run the script from an elevated PowerShell session on the machine you wish to unlink the ESU license from.
# Note that this runs in the context of the logged on user via Connect-AzAccount.

# You will need to provide the following information:
$subId = "SUBSCRIPTION_ID"
$resGroup = "RESOURCE_GROUP_NAME"
$machineName = "MACHINE_NAME"
$region = "REGION"

$uri = https://management.azure.com/subscriptions/$subId/resourceGroups/$resGroup/providers/Microsoft.HybridCompute/machines/$machineName/licenseProfiles/default?api-version=2023-06-20-preview
$token = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com').Token
$headers = @{
    Authorization = "Bearer $token"
}
$body = @"
{
"location": "$region",
"properties": {
   "esuProfile": {
   }
}
}
"@
Invoke-WebRequest -Uri $uri -Method Put -Body $body -Headers $headers -ContentType "application/json"
