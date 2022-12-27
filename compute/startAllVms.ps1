# GetVms
$VMNames = (Get-AzVM | Select-Object Name).Name

# Loop&StartEach
foreach($VMName in $VMNames)
{
    Write-Host "starting $VMName"
    Get-AzVM -Name $VMName | Start-AzVM -NoWait
}