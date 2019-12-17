# Create a quick VM
# Connect-AzAccount

#var
$subscription = Read-Host -Prompt "Enter your Azure subscription name"

Set-AzContext -SubscriptionName $subscription

New-AzVM -Name MyVm -Credential (Get-Credential)