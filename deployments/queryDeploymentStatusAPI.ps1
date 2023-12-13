
#parameters required to run the script
param(
    [Parameter(Mandatory=$true)]
    [string]$subscriptionId,

    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$deploymentName
)

#get the token of logged in user
$token = Get-AzAccessToken | select -ExpandProperty Token
$authHeader = @{
  'Content-Type'='application/json'
  'Authorization'='Bearer ' + $token
}
#$subID = (get-azsubscription).id
#echo $authHeader
#build the uri
$uri = 'https://management.azure.com/subscriptions/' + $subscriptionId + '/resourcegroups/' + $resourceGroupName + '/providers/Microsoft.Resources/deployments/' + $deploymentName + '?api-version=2021-04-01'
#echo $uri

#invoke the rest method
$deployState = (invoke-restmethod -method GET -uri $uri -headers $authHeader)

#return the provisioning state (Running, Succeeded, Failed, etc.)
$deployState.properties.provisioningState