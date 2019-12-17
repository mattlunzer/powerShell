
#set var
$rg = <resourceGroupName>
$vm = <computerName>
$region = <region>
$fileUri = 
$fileName = <filename>

Set-AzVMCustomScriptExtension -ResourceGroupName $rg `
    -VMName $vm `
    -Location $region `
    -FileUri $fileUri `
    -Run $fileName `
    -Name DemoScriptExtension  