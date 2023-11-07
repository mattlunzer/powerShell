resourceGroup = "RG-NAME"
$virtualMachine = "VIRTUALMACHINE-NAME"
#Remove page file from Temporary Storage drive D and set page file on drive C
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -Name $virtualMachine -CommandId 'RunPowerShellScript' -ScriptString '$CurrentPageFile = Get-WmiObject -Query "select * from Win32_PageFileSetting"; $CurrentPageFile.delete(); Set-WMIInstance -Class Win32_PageFileSetting -Arguments @{name="c:\pagefile.sys";InitialSize = 0; MaximumSize = 0}'
#Restart the VM to apply the changes
Restart-AzVM -ResourceGroupName $resourceGroup -name $virtualMachine
#Change the drive letter of the temporary storage drive D to Z and set page file on drive Z
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -Name $virtualMachine -CommandId 'RunPowerShellScript' -ScriptString 'Get-partition | Where-Object {$_.DriveLetter -eq "D"} | Set-Partition -NewDriveLetter Z; $CurrentPageFile = Get-WmiObject -Query "select * from Win32_PageFileSetting"; $CurrentPageFile.delete(); Set-WMIInstance -Class Win32_PageFileSetting -Arguments @{name="z:\pagefile.sys";InitialSize = 0; MaximumSize = 0}'
#Restart the VM to apply the changes
Restart-AzVM -ResourceGroupName $resourceGroup -name $virtualMachine
