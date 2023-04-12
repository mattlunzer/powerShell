#Connect to your Azure subscription
#Connect-AzAccount

#provide storage account name e.g., storageacct1
$storageAccountname=

#get conntext object using Azure AD credentials
$ctx = New-AzStorageContext -StorageAccountName $storageAccountname -UseConnectedAccount

#Create a container object
$container = Get-AzStorageContainer -Name "malware" -Context $ctx

#Set variables
$file = ".\eicar.com.txt" 
#$file = "" 
$containerName = "malware"

#Upload a single named file
Set-AzStorageBlobContent -File $file -Container $containerName -Context $ctx -Forcegi