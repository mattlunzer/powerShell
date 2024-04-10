#setVariable
$ver = "1245"
$subscriptionId=$(az account show `
    --query id `
    --output tsv)
$location="eastus"
$rgName="rg-cvm-cmk-demo-new-"+$ver
$kvName="kv-cvm-cmk-rbac-new-"+$ver
$vmName = "cvm-cmk-rhel-"+$ver
$userMI = "cvm-cmk-mi-04102024-"+$ver
$diskEncSet = "cvm-cmk-des-rbac-"+$ver
$Password = ""

# set the subscription
az account set --subscription $subscriptionId

#Create Resource Group
az group create --location $location --resource-group $rgName

#create KeyVault
az keyvault create -n $kvName -g $rgName --enabled-for-disk-encryption true --sku premium --enable-purge-protection true --enable-rbac-authorization

# add permission for this user 
$currentUser = az account show --query user.name -o tsv
$myId = az ad user show --id $currentUser --query "id" --output tsv 
az role assignment create --role "Key Vault Crypto Officer" --assignee-object-id $myId --scope /subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.KeyVault/vaults/$kvName

#Add Confidential VM Orchestrator to a variable
$cvmAgentID = (az ad sp show --id "bf7b6499-ff71-4aa2-97a4-f372087be7f0" | ConvertFrom-Json).id

#az role assignment create --role "Key Vault Crypto Officer" for Confidential VM Orchestrator
az role assignment create --role "Key Vault Crypto Officer"  --assignee-object-id $cvmAgentID --scope /subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.KeyVault/vaults/$kvName

#Create KeyVault Key
az keyvault key create --name cvm-cmk-key1 --vault-name $kvName --default-cvm-policy --exportable --kty RSA-HSM

#create user MI
az identity create --resource-group $rgName --name $userMI

#Get MI PricipalID
$miPrincipalId = az identity show --resource-group $rgName --name $userMI --query principalId -o tsv

#create role assignment for the user MI (principal ID)
az role assignment create --role "Key Vault Crypto User" --assignee-object-id $miPrincipalId --scope /subscriptions/$subscriptionId/resourceGroups/$rgName/providers/Microsoft.KeyVault/vaults/$kvName

#get MI id
$miID = az identity show --resource-group $rgName --name $userMI --query id -o tsv

#Create Disk Encryption Set with user MI
$keyVaultKeyUrl=(az keyvault key show --vault-name $kvName --name cvm-cmk-key1 --query [key.kid] -o tsv)
az disk-encryption-set create --resource-group $rgName --name $diskEncSet --key-url $keyVaultKeyUrl  --encryption-type ConfidentialVmEncryptedWithCustomerKey --mi-user-assigned $miID

#create vm with DES
az vm create `
--resource-group $rgName `
--name $vmName `
--size Standard_DC2ads_v5 `
--admin-username "azureuser" `
--admin-password "" `
--enable-vtpm true `
--enable-secure-boot true `
--image "RedHat:rhel-cvm:9_3_cvm_sev_snp:9.3.2023111017" `
--public-ip-sku Standard `
--security-type ConfidentialVM `
--os-disk-security-encryption-type DiskWithVMGuestState `
--os-disk-secure-vm-disk-encryption-set $diskEncSet
