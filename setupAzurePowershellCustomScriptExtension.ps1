
#set var
$rg = <resourceGroupName>
$vm = <computerName>
$region = <region>
$fileUri = https://raw.githubusercontent.com/mattlunzer/powerShell/master/
$fileName = setupAzurePowershellCustomScriptExtension.ps1

Set-AzVMCustomScriptExtension -ResourceGroupName $rg `
    -VMName $vm `
    -Location $region `
    -FileUri $fileUri `
    -Run $fileName `
#    -Name DemoScriptExtension  