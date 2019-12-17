# Create a detailed VM
# Connect-AzAccount

#$subscription = subscription1
#Set-AzContext -SubscriptionName $subscription

$rg = 'myResourceGroupDemo'
$vmName = 'myVM1'
$location = 'EastUS'
$size = 'Standard_D2s_v3'

New-AzResourceGroup -ResourceGroupName $rg -Location $location

$imageName = 'Win2016Datacenter'

$vmParams = @{
   ResourceGroupName = $rg
   Name = $vmName
   Location = $location
   ImageName = $imageName
   size = $size
 }
 $newVM1 = New-AzVM @vmParams