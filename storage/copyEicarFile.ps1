#Connect to your Azure subscription
#Connect-AzAccount

#get conntext object using Azure AD credentials
$ctx = New-AzStorageContext -StorageAccountName dmsstorageacct1 -UseConnectedAccount

#Create a container object
$container = Get-AzStorageContainer -Name "malware" -Context $ctx

#Set variables
$file = "C:\Malware\eicar.com.txt" 
#$file = "C:\Malware\readme.txt" 
$containerName = "malware"

#Upload a single named file
Set-AzStorageBlobContent -File $file -Container $containerName -Context $ctx -Force