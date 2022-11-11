#replace var with desired value. Use Get-AzVMSize to obtain sizes 
$vmSku = "Standard_E8as_v5"

$locations = (Get-AzLocation | Where-Object {$_.RegionType -ne "Logical"} | Sort-Object -Property Location | Select-Object Location).Location

foreach ($location in $locations){
    $VmByRegion = Get-AzComputeResourceSKU -Location $location | Where-Object {$_.Name -eq $vmSku -and $_.Restrictions.ReasonCode -ne 'NotAvailableForSubscription'}
    If ($VmByRegion.Name -eq $vmSku)
        {Write-Host $location ":" $vmByRegion.Name}
    else {
        Write-Host $location ":" "Not Available"
    }
}
