
#parameters required to run the script
param(
    [Parameter(Mandatory=$true)]
    [string]$username,
    
    [Parameter(Mandatory=$true)]
    [string]$subscriptionName,

    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$virtualMachineName
)

New-AzRoleAssignment -SignInName $username -RoleDefinitionName "Virtual Machine Administrator Login" -Scope "/subscriptions/$subscriptionName/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/virtualMachines/$virtualMachineName"
