
$subscriptionId=$(az account show `
    --query id `
    --output tsv)
$location="eastus"
$rgName="rg-cvm-cmk-demo"
$kvName="keyvault-cvm-cmk"
$vmName = "cvm-cmk-rhel4"


$keyvault = Get-AzKeyVault -VaultName $kvName -ResourceGroupName $rgName
if ($keyvault -eq $null)
{
    Write-Error("Failed to locate $kvName keyvault in $rgName")
    break __Exit
}

# ADE settings:
$Publisher                   = "Microsoft.Azure.Security"
$ExtName                     = "AzureDiskEncryptionForLinux"
$ExtHandlerVer               = "1.4"
$EncryptionOperation         = "EnableEncryption"

# Settings for enabling temp disk encryption only providing Azure Key Vault resource.
$pubSettings                 = @{};
$pubSettings.Add("VolumeType", "Data")
$pubSettings.Add("EncryptionOperation", $EncryptionOperation)
$pubSettings.Add("KeyVaultURL", $keyvault.VaultUri)
$pubSettings.Add("KeyVaultResourceId", $keyvault.ResourceId)

Set-AzVMExtension `
    -ResourceGroupName $rgName `
    -VMName $vmName `
    -Publisher $Publisher `
    -ExtensionType $ExtName `
    -TypeHandlerVersion $ExtHandlerVer `
    -Name $ExtName `
    -EnableAutomaticUpgrade $false `
    -Settings $pubSettings `
    -Location $location

# Verify: switch to the portal and verify that the extension provision is succeded.
Write-Host "Waiting 2 minutes for extension status update"
Start-Sleep 120
$status = Get-AzVMExtension -ResourceGroupName $rgName -VMName $vmName -Name $ExtName -Status
$status
$status.SubStatuses
