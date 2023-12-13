
#parameters required to run the script
param(
    [Parameter(Mandatory=$true)]
    [string]$subscriptionId,

    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$vmName,

    [Parameter(Mandatory=$false)]
    [bool]$hibernate=$true
)

#get the token of logged in user
#$token = Get-AzAccessToken | select -ExpandProperty Token
$token = Get-AzAccessToken | Select-Object -ExpandProperty Token
$authHeader = @{
  'Content-Type'='application/json'
  'Authorization'='Bearer ' + $token
}

#build the uri
$uri = 'https://management.azure.com/subscriptions/' + $subscriptionId + '/resourcegroups/' + $resourceGroupName + '/providers/Microsoft.Compute/virtualMachines/' + $vmName + '/deallocate?hibernate=' + $hibernate + '&api-version=2023-07-01'
#echo $uri

#invoke the rest method
$deployState = (invoke-restmethod -method POST -uri $uri -headers $authHeader)

#return the provisioning state (Running, Succeeded, Failed, etc.)
$deployState.properties.provisioningState