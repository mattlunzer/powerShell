
#set variables
$resourceGroup = 'CustomImageTemplate'
$location = 'eastus'
$userMI = 'CustomImageTemplateUserMI'
$subscriptionID = $(Get-AzSubscription).Id

#verify RPs
Get-AzResourceProvider -ListAvailable | 
Where-Object {$_.ProviderNamespace -eq 'Microsoft.DesktopVirtualization' -or $_.ProviderNamespace -eq 'Microsoft.VirtualMachineImages' -or $_.ProviderNamespace -eq 'Microsoft.Storage' -or $_.ProviderNamespace -eq 'Microsoft.Compute' -or $_.ProviderNamespace -eq 'Microsoft.Network' -or $_.ProviderNamespace -eq 'Microsoft.KeyVault'} | 
Select-Object ProviderNamespace, RegistrationState 

#create RG
New-AzResourceGroup -Name $resourceGroup -location $location

#create MI
New-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -Name $userMI -location $location

#create role definition
New-AzRoleDefinition -InputFile ".\aibCustomRole.Json"
$userMIid = (Get-AzADServicePrincipal -DisplayName $userMI).id

#Assign Role
New-AzRoleAssignment -ObjectId $userMIid -RoleDefinitionName "Custom Role for Custom Image Templates" -Scope "/subscriptions/$subscriptionID"
