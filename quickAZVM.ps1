# Create a quick VM
# Connect-AzAccount

Set-AzContext -SubscriptionName $subscription

#var
$subscription = subscription1

New-AzVM -Name MyVm -Credential (Get-Credential)