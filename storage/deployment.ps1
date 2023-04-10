
$resourceGroupName = "RG-AVforBlobDemo"
$location = "eastus"
$storageAccountName = "mystorageaccount"
$containerNames = @("upload", "quarantine")

# Create a new resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a new storage account
New-AzStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -AccessTier Hot

# Create two new containers
foreach ($containerName in $containerNames) {
    New-AzStorageContainer -Name $containerName `
        -Context (New-AzStorageContext `
            -StorageAccountName $storageAccountName `
            -UseConnectedAccount) `
        -Permission Off
}