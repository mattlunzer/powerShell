$rg="myWebApp"
$webappname="mywebapp$(Get-Random)"
$location="CentralUS"

# Create a resource group.
New-AzResourceGroup -Name $rg -Location $location

# Create an App Service plan
New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName $rg -Tier Standard

# Create a web app.
New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname -ResourceGroupName $rg

# apply custom domain - no workie
#Set-AzWebApp -NYame $webappname -ResourceGroupName $rg -HostNames @($fqdn,"$webappname.azurewebsites.net")