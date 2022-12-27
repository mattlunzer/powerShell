# GetVmResourceIds
$VMIds = (Get-AzVM | Select-Object Id).Id

# Loop&StopEach
foreach($VMId in $VMIds){
    $Tags = (Get-AzTag -ResourceId $VMId).Properties

    #If resource tag key is shutdown AND value is true, shut down VM
    if ($Tags.TagsProperty.ContainsKey('Shutdown') -and ($Tags.TagsProperty.ContainsValue('True'))) {
        Get-AzVM -ResourceId $VMId | Stop-AzVM -Force -NoWait
        $VMName = ($VMId.Split('/')[-1])
        Write-Host "Stopping $VMName" 
    }
    else {
        $VMName = ($VMId.Split('/')[-1])
        Write-Host "Shutdown:True key value not configured for $VMName. Leave running"
    }
}