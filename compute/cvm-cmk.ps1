#setVariable
$location="eastus"
$rgName="rg-cvm-cmk-demo"
$kvName="keyvault-cvm-cmk"
$vmName = "cvm-cmk-rhel5"
$Password = ""

#Create Resource Group
az group create --location $location --resource-group $rgName

#create KeyVault
az keyvault create -n $kvName -g $rgName --enabled-for-disk-encryption true --sku premium --enable-purge-protection true

#configure KeyVault for CVM
$cvmAgent=az ad sp show --id "bf7b6499-ff71-4aa2-97a4-f372087be7f0" | Out-String | ConvertFrom-Json
az keyvault set-policy --name $kvName --object-id $cvmAgent.Id --key-permissions get release

#Create KeyVault Key
az keyvault key create --name cvm-cmk-key1 --vault-name $kvName --default-cvm-policy --exportable --kty RSA-HSM

#Create Disk Encryption Set
$keyVaultKeyUrl=(az keyvault key show --vault-name $kvName --name cvm-cmk-key1 --query [key.kid] -o tsv)
az disk-encryption-set create --resource-group $rgName --name cvm-cmk-des --key-url $keyVaultKeyUrl  --encryption-type ConfidentialVmEncryptedWithCustomerKey

#Assign KeyVault Key to Disk Encryption Set
$desIdentity=(az disk-encryption-set show -n cvm-cmk-des -g $rgName --query [identity.principalId] -o tsv)
az keyvault set-policy -n $kvName -g $rgName --object-id $desIdentity --key-permissions wrapkey unwrapkey get

#Create VM
$diskEncryptionSetID=(az disk-encryption-set show -n cvm-cmk-des -g $rgName --query [id] -o tsv)

az vm create `
--resource-group $rgName `
--name $vmName `
--size Standard_DC2ads_v5 `
--admin-username "azureuser" `
--admin-password "12345qwert!!" `
--enable-vtpm true `
--enable-secure-boot true `
--image "RedHat:rhel-cvm:9_3_cvm_sev_snp:9.3.2023111017" `
--public-ip-sku Standard `
--security-type ConfidentialVM `
--os-disk-security-encryption-type DiskWithVMGuestState `
--os-disk-secure-vm-disk-encryption-set $diskEncryptionSetID 
