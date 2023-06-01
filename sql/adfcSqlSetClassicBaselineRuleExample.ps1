
# Run powershell script with the subscription name
PARAM(
    [string] [Parameter(Mandatory = $True, HelpMessage = "Choose subscription you want be inventored")] $SubscriptionName
    )

Get-AzSubscription -SubscriptionName $SubscriptionName | Select-AzSubscription

#get all the Azure SQL Servers
$AzureSQLServers = Get-AzResource  | Where-Object ResourceType -EQ Microsoft.SQL/servers
#Write-Output $($AzureSQLServer).ResourceGroupName
#Write-Output $($AzureSQLServers).Name

#loop through all the Azure SQL Servers
foreach ($AzureSQLServer in $AzureSQLServers){
    $AzureSQLServerDataBases = Get-AzSqlDatabase -ServerName $AzureSQLServer.Name -ResourceGroupName $AzureSQLServer.ResourceGroupName | Where-Object DatabaseName -NE "master"
    #Write-Host $AzureSQLServerDataBases
    foreach ($AzureSQLServerDataBase in $AzureSQLServerDataBases){
        #Write-Host "Database: " $($AzureSQLServerDataBase).DatabaseName
        #Set the baseline for the rule VA1258
        Set-AzSqlDatabaseVulnerabilityAssessmentRuleBaseline `
        -ResourceGroupName  $AzureSQLServer.ResourceGroupName `
        -ServerName $AzureSQLServer.Name `
        -DatabaseName $AzureSQLServerDataBase.DatabaseName `
        -BaselineResult @('user1', 'user2', 'user3', 'user4') `
        -RuleID 'VA1258'
        #Start the scan for the rule VA1258
        Start-AzSqlDatabaseVulnerabilityAssessmentScan `
        -ResourceGroupName  $AzureSQLServer.ResourceGroupName `
        -ServerName $AzureSQLServer.Name `
        -DatabaseName $AzureSQLServerDataBase.DatabaseName
    }
}